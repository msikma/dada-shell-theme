// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>

const chalk = require('chalk').default
const { sortGen, hardPad, isArray, niceStatus, findLargest, weightStatus, weightPriority, keyMap } = require('./helpers')
const { tableAssets } = require('./assets')

/** Some columns are mapped to a different column
 * (e.g. 'priority' strings get mapped to priority icons instead). */
const colMappings = {
  status: 'statusNice',
  type: 'taskIcon',
  priority: 'priorityIcon'
}

/** Make some changes to the Jira data before rendering the table. */
const preprocessData = (data, assets) => data.map(item => ({
  ...item,
  taskIcon: taskIcon(item.type, assets),
  priorityIcon: priorityIcon(item.priority, assets),
  priorityColor: assets.colors[item.priority],
  statusNice: niceStatus(item.status),
  // Add weights to easily sort items later on.
  statusWeight: weightStatus(item.status),
  priorityWeight: weightPriority(item.priority)
}))

/** Returns an icon string for the task type. */
const taskIcon = (task, assets) => ({
  'Sub-task': [assets.icons.ticketSubtask, chalk.dim.cyan],
  'Task': [assets.icons.ticketTask, chalk.cyan],
  'Bug': [assets.icons.ticketBug, chalk.red],
  'Epic': [assets.icons.ticketEpic, chalk.magenta],
  'Story': [assets.icons.ticketStory, chalk.green]
}[task] || '?')

/** Returns a string icon for the priority. */
const priorityIcon = (prio, assets) => ({
  highest: [assets.icons.arrUp, assets.colors.highest],
  high: [assets.icons.arrUp, assets.colors.high],
  medium: [assets.icons.arrMiddle, assets.colors.medium],
  low: [assets.icons.arrDown, assets.colors.low],
  lowest: [assets.icons.arrDown, assets.colors.lowest]
}[prio] || '?')

/** How many spaces to put before sub-tasks. */
const subTaskIndent = 2

/** Generates a single table row containing the information of one task. */
const _tableTaskRow = ({ rowData, cols, colDynamic, colMappings, colSizes, screenWidth }) => {
  // We'll calculate the size of the dynamic column while rendering the other columns.
  // The width is the screen width minus all the other columns.
  let colDynamicSize = screenWidth
  const isSubTask = rowData['type'] === 'Sub-task'

  const colData = {}
  for (const col of cols) {
    const key = keyMap(col, colMappings)
    if (key === colDynamic) continue
    const keyChars = colSizes[key]
    const keyData = rowData[key]

    // If the data is an array, only the first character is printable;
    // and the second item is a color function to wrap it in.
    const dataRaw = isArray(keyData) ? keyData[0] : keyData
    const dataWrapper = isArray(keyData) ? keyData[1] : (str) => str

    const data = hardPad(dataRaw, keyChars)

    // Subtract this column's width from the dynamic column's size.
    colDynamicSize -= keyChars

    colData[key] = dataWrapper(data)
  }

  // Also account for the padding, and the sub-task indent.
  colDynamicSize -= cols.length - 1 + (isSubTask ? subTaskIndent : 0)

  // Now set the dynamic column using the size we calculated.
  // The 'summary' column is never mapped to another and is never an array.
  colData['summary'] = hardPad(rowData[colDynamic], colDynamicSize)

  return [
    isSubTask ? `${' '.repeat(subTaskIndent)}${colData['taskIcon']}` : colData['taskIcon'],
    chalk.dim.gray(colData['key']),
    colData['priorityIcon'],
    rowData.priorityColor(colData['summary']),
    colData['statusNice'],
    chalk.dim.gray(colData['link'])
  ].join(' ')
}

/** Returns a separator with a header text that indicates a new grouped series of tasks. */
const _tableTaskHeader = ({ cols, colHead, colDynamic, colMappings, colSizes, screenWidth, assets }) => {
  // FIXME
  // The header goes in the place where the summary also goes.
  // We'll calculate the width on the left side, then subtract it and the header size for the rest.
  let sizeLeft = 0
  const buffer = []

  const dynIdx = cols.findIndex(col => keyMap(col, colMappings) === colDynamic)
  const leftCols = cols.slice(0, dynIdx)

  for (const col of leftCols) {
    const key = keyMap(col, colMappings)
    const size = colSizes[key]
    if (size == null) continue
    sizeLeft += size
  }
  sizeLeft += leftCols.length - 1
  buffer.push(assets.box.top.repeat(sizeLeft))
  buffer.push(` ${colHead} `)
  buffer.push(assets.box.top.repeat(screenWidth - (colHead.length + 2) - sizeLeft))

  return buffer
}

/**
 * Creates a table displaying issues from a provided layout and data object.
 *
 * @param   {array}   rawJiraData Array of Jira issues, i.e. { tasks: {array} }
 * @param   {string}  screenWidth Width in characters of the table to generate
 * @param   {string}  layout      Object with column type and size information
 * @param   {string}  assets      Object containing special characters for drawing purposes
 * @param   {boolean} displayDone Whether to show the issues that are done
 * @returns {array}               Array of lines comprising the table
 */
const makeTable = (rawJiraData, screenWidth, layout, assets = tableAssets, displayDone = false) => {
  // The data contains two items: 'projects' and 'tasks'.
  const rawData = rawJiraData.tasks
  if (!rawData || !Object.keys(rawData).length) {
    throw new Error('No Jira data found')
  }
  // Sorting function that takes Jira data into account.
  const jiraSorter = sortGen(['statusWeight', 'priorityWeight', 'key'])

  // Tasks will be listed by status, priority and key - but subtasks will always appear
  // underneath their parent task. In order to do this, we'll split the issues list
  // into regular tasks and subtasks, sort both, and then reintegrate them.
  const regTasks = jiraSorter(preprocessData(rawData.filter(t => t.type !== 'Sub-task'), assets))
  const subTasks = jiraSorter(preprocessData(rawData.filter(t => t.type === 'Sub-task'), assets))
  const allTasks = regTasks.reduce((tasks, task) => {
    const childTasks = subTasks.filter(t => t.parent === task.key)
    return [...tasks, task, ...childTasks]
  }, [])

  // The key used to display headers above groups of tasks.
  const colHeaderKey = 'statusNice'

  // List the largest items for each key to determine their column sizes.
  // Some items are arrays: in that case the first item is the column content,
  // and the second item is a color function that shouldn't be counted.
  const allCols = Object.keys(allTasks[0])
  const colSizes = allCols.reduce((cols, key) => ({ ...cols, [key]: findLargest(key, allTasks) }), {})

  // These are the variables passed on to the drawing functions.
  const { cols, colDynamic } = layout
  const layoutArgs = { cols, colDynamic, colMappings, colSizes, screenWidth, assets }

  const taskRows = []
  let lastHeader = null
  for (const row of allTasks) {
    const colHead = row[colHeaderKey]
    const colStatus = row['status']
    if (!displayDone && colStatus === 'done') {
      continue
    }
    if (lastHeader !== colHead) {
      lastHeader = colHead
      taskRows.push(_tableTaskHeader({ ...layoutArgs, colHead }))
    }
    taskRows.push(_tableTaskRow({ ...layoutArgs, rowData: row }))
  }

  return taskRows.map(row => isArray(row) ? row.join('') : row)
}

module.exports = {
  makeTable
}
