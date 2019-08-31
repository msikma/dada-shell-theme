#!/usr/bin/env node

// Small script that prints Jira task information scraped by ms-jira-cli.
// Copyright (C) 2018, Michiel Sikma <michiel@sikma.org>
//
// In progress items are sorted to the top, then todo items, then done items.

const process = require('process')
const { execSync } = require('child_process')
const { existsSync, readFileSync } = require('fs')
const { homedir } = require('os')

// Set the path to the user's Jira tasks cache.
const home = homedir()
const cachePath = `${home}/.cache/dada/jira.json`

// Used for strings that don't fit.
const ellipsis = '…'

// Terminal width
const cols = process.stdout.columns

// Terminal color escape codes
// <https://stackoverflow.com/a/41407246>
const color = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  dim: '\x1b[2m',
  underline: '\x1b[4m',

  fgRed: '\x1b[31m',
  fgBrRed: '\x1b[91m',
  fgGreen: '\x1b[32m',
  fgBrGreen: '\x1b[92m',
  fgYellow: '\x1b[33m',
  fgBrYellow: '\x1b[93m',
  fgBlue: '\x1b[34m',
  fgBrBlue: '\x1b[94m',
  fgMagenta: '\x1b[35m',
  fgBrMagenta: '\x1b[95m',
  fgCyan: '\x1b[36m',
  fgBrCyan: '\x1b[96m',
  fgBlack: '\x1b[30m',
  fgBrBlack: '\x1b[90m',

  fgOrange: '\x1b[38;5;208m',

  bgRed: '\x1b[41m',
  bgGreen: '\x1b[42m',
  bgYellow: '\x1b[43m',
  bgBlue: '\x1b[44m',
  bgMagenta: '\x1b[45m',
  bgCyan: '\x1b[46m'
}

// List of icons and arrows to use for task and priority.
const icons = {
  arrUp: '\u2191',
  arrMiddle: '•',
  arrDown: '\u2193',

  task: '✓',
  bug: '✗',
  story: '*',
  epic: 'e',
  subtask: '└'
}

// Box drawing characters for displaying alert boxes.
const box = {
  tl: '╭',
  t: '─',
  tr: '╮',
  l: '│ ',
  r: ' │',
  bl: '╰',
  b: '─',
  br: '╯',

  hdown: '┬',
  hup: '┴'
}

/** Helper function for accurately calculating string length when Japanese is present. */
const JPN = /[\u3000-\u303f\u3040-\u309f\u30a0-\u30ff\uff00-\uff5f\u4e00-\u9faf\u3400-\u4dbf]/g
const lengthUCS2 = (str) => {
  const strCopy = str.replace(JPN, 'xx')
  return strCopy.length
}

/** Helper function used to exit the script quickly. Does not exit immediately,
 *  but sets the exit code for when exiting gracefully. */
const error = reason => {
  console.log(`jira-list.js: Error: ${reason}`)
  process.exitCode = 1
}

/** Returns Jira info in JSON format using the ms-jira-cli program. */
const getJiraData = () => {
  if (existsSync(cachePath)) {
    return JSON.parse(readFileSync(cachePath))
  }
  try {
    const stdout = execSync('ms-jira-cli --action data --output json')
    const data = JSON.parse(stdout.toString('utf8'))
    return data
  }
  catch (err) {
    error('Could not retrieve Jira info.\n' + err.stdout)
  }
}

/** Preprocesses data from ms-jira-cli. */
const preprocessJiraData = (data) => data.map(item => ({
  ...item,
  statusNice: niceStatus(item.status),
  // Add weights to easily sort items later on.
  statusWeight: weightStatus(item.status),
  priorityWeight: weightPriority(item.priority)
}))

/** Makes the status display slightly nicer. Keeps the original string if we don't recognize it. */
const niceStatus = (status) => ({ to_do: 'To do', in_progress: 'In prog.', done: 'Done' }[status] || status)
const niceStatusHeader = (status) => ({ to_do: 'To do', in_progress: 'In progress', done: 'Done (recently)' }[status] || status)

/** Returns a Unicode icon for the task type. */
const taskIcon = (task) => ({
  'Sub-task': color.dim + color.fgCyan + icons.subtask + color.reset,
  'Task': color.fgCyan + icons.task + color.reset,
  'Bug': color.fgRed + icons.bug + color.reset,
  'Epic': color.fgMagenta + icons.epic + color.reset,
  'Story': color.fgGreen + icons.story + color.reset
}[task] || '?')

/** Returns a Unicode icon for the priority. */
const priorityIcon = (prio) => ({
  highest: color.fgRed + icons.arrUp + color.reset,
  high: color.fgOrange + icons.arrUp + color.reset,
  medium: color.fgYellow + icons.arrMiddle + color.reset,
  low: color.fgGreen + icons.arrDown + color.reset,
  lowest: color.dim + color.fgGreen + icons.arrDown + color.reset
}[prio] || '?')

/** Returns text colors for the priority. */
const textColor = (prio) => ({
  highest: [color.fgRed, color.fgBlack],
  //high: [color.fgRed, color.fgBlack],
  high: [color.fgOrange, color.fgBlack],
  medium: [color.fgYellow, color.fgBlack],
  low: [color.fgBrGreen, color.fgBlack],
  lowest: [color.fgGreen, color.fgBlack]
}[prio] || '')

/** Find the largest item 'key' in an array of objects. */
const findLargest = (key, data) => data.reduce(((l, item) => item[key].length > l ? item[key].length : l), 0)

/** Assigns an integer importance to a status value. Lower is more important. */
const weightStatus = (status) => ({ to_do: 20, in_progress: 10, done: 30 }[status] || status)

/** Assigns an integer importance to a priority value. Lower is more important. */
const weightPriority = (prio) => ({ highest: 10, high: 20, medium: 30, low: 40, lowest: 50 }[prio] || prio)

/** Crops and pads a string to a specific length. */
const crop = (str, len, padder = ' ') => (str + padder.repeat(len)).slice(0, len)

/** Generates a simple sorting function that uses multiple keys. */
const sortGen = keys => data => data.sort((a, b) => {
  for (key of keys) {
    if (a[key] > b[key]) return 1
    if (a[key] < b[key]) return -1
    continue
  }
  return 0
})

/** Repeats a character. */
const repeat = (char, length) => (
  char.repeat(length)
)

/** Prints the top of the table. */
const printTableTop = (largest) => {
  console.log([
    box.tl,
    box.t,
    box.hdown,
    repeat(box.t, largest.key),
    box.hdown,
    box.t,
    box.hdown,
    repeat(box.t, cols - 2 - 2 - largest.key - 2 - largest.statusNice - 2 - largest.link - 2),
    box.hdown,
    repeat(box.t, largest.link),
    box.hdown,
    repeat(box.t, largest.statusNice),
    box.tr
  ].join(''))
}

// Runs the main program.
//
// Each task has the following data:
//
//   { key: 'KMK-3',
//     type: 'Sub-task',
//     summary: 'Finalize Tumblr code',
//     link: 'http://jira.theorycraft.fi/browse/KMK-3',
//     priority: 'medium',
//     status: 'done',
//     assignee: 'Unassigned',
//     parent: 'KMK-2' }
//
// 'parent' might be null if it isn't a sub-task.
//
// Priority and task type are displayed as an icon.

const main = () => {
  // Retrieve data or exit program if something went wrong.
  const rawData = getJiraData()
  if (!rawData) return

  // Tasks will be listed by status, priority and key - but subtasks will always appear
  // underneath their parent task. In order to do this, we'll split the issues list
  // into regular tasks and subtasks, sort both, and then reintegrate them.

  // Sorting function that takes Jira data into account.
  const jiraSorter = sortGen(['statusWeight', 'priorityWeight', 'key'])

  const regTasks = jiraSorter(preprocessJiraData(rawData.filter(t => t.type !== 'Sub-task')))
  const subTasks = jiraSorter(preprocessJiraData(rawData.filter(t => t.type === 'Sub-task')))
  const allTasks = regTasks.reduce((tasks, task) => {
    const childTasks = subTasks.filter(t => t.parent === task.key)
    return [...tasks, task, ...childTasks]
  }, [])

  // List the largest items for each key, which we'll use as size for that column
  const largest = {
    key: findLargest('key', allTasks),
    priority: findLargest('priority', allTasks),
    statusNice: findLargest('statusNice', allTasks),
    link: findLargest('link', allTasks),
    assignee: findLargest('assignee', allTasks) // Currently unused.
  }

  printTableTop(largest)

  // Iterate over the data to print it line by line.
  let currStatus
  allTasks.forEach(item => {
    const printHeader = item.status !== currStatus
    const activeColors = textColor(item.priority)
    const isChild = item.parent
    const itemLink = item.link
    const priorityArrow = priorityIcon(item.priority) // priorityIcon(['highest', 'high', 'medium', 'low', 'lowest'][Math.round(Math.random() * 4)])
    const taskItem = taskIcon(item.type) // taskIcon(['Sub-task', 'Task', 'Bug', 'Epic', 'Story'][Math.round(Math.random() * 4)])

    // Add an ellipsis at the end of the summary if we can't display it all.
    const summaryLength = cols - 2 - 2 - largest.key - 2 - largest.statusNice - 2 - largest.link - 2
    const summaryLengthPadded = isChild ? summaryLength - 2 : summaryLength
    const summary = item.summary.length > summaryLengthPadded
      ? item.summary.slice(0, summaryLengthPadded - 1).trim() + ellipsis
      : item.summary

    currStatus = item.status

    if (printHeader) {
      const header = niceStatusHeader(item.status)
      const leftPad = 3 + largest.key + 3 - 1
      const rightPad = cols - leftPad - header.length - 2
      console.log(`${crop('─', leftPad, '─')} ${header} ${crop('─', rightPad, '─')}`)
    }
    console.log([
      // Indent, in case this is a child task
      isChild ? '   ' : ' ',
      // Task icon
      taskItem,
      ' ',
      // Key, e.g. 'KMK-5'
      activeColors[1],
      item.key,
      color.reset,
      ' '.repeat(largest.key - item.key.length + 1),
      // Priority icon
      priorityArrow,
      ' ',
      // Summary (cropped/padded to max. length)
      activeColors[0],
      color.underline,
      crop(summary, summaryLengthPadded),
      color.reset,
      ' ',
      // Link
      activeColors[1],
      itemLink.padEnd(largest.link),
      color.reset,
      ' ',
      // Status
      item.statusNice,
      color.reset,
    ].join(''))
  })
}

main()
