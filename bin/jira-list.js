#!/usr/bin/env node

// Small script that prints Jira task information scraped by ms-jira-cli.
// Copyright (C) 2018, Michiel Sikma <michiel@sikma.org>
//
// In progress items are sorted to the top, then todo items, then done items.

const process = require('process')
const { execSync } = require('child_process')

// Terminal width
const cols = process.stdout.columns

// Terminal color escape codes
// <https://stackoverflow.com/a/41407246>
const color = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  dim: '\x1b[2m',

  fgRed: '\x1b[31m',
  fgGreen: '\x1b[32m',
  fgYellow: '\x1b[33m',
  fgBlue: '\x1b[34m',
  fgMagenta: '\x1b[35m',
  fgCyan: '\x1b[36m',

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
  arrDown: '\u2193',

  task: '✓',
  bug: '✗',
  story: '*',
  epic: 'e',
  subtask: '└'
}

/** Helper function used to exit the script quickly. Does not exit immediately,
 *  but sets the exit code for when exiting gracefully. */
const error = reason => {
  console.log(`jira-list.js: Error: ${reason}`)
  process.exitCode = 1
}

/** Returns Jira info in JSON format using the ms-jira-cli program. */
const getJiraData = () => {
  try {
    const stdout = execSync('ms-jira-cli --action list --output json')
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
  highest: color.dim + color.fgRed + icons.arrUp + color.reset,
  high: color.fgRed + icons.arrUp + color.reset,
  medium: color.fgYellow + icons.arrUp + color.reset,
  low: color.fgGreen + icons.arrDown + color.reset,
  lowest: color.dim + color.fgGreen + icons.arrDown + color.reset
}[prio] || '?')

/** Find the largest item 'key' in an array of objects. */
const findLargest = (key, data) => data.reduce(((l, item) => item[key].length > l ? item[key].length : l), 0)

/** Assigns an integer importance to a status value. Lower is more important. */
const weightStatus = (status) => ({ to_do: 20, in_progress: 10, done: 30 }[status] || status)

/** Assigns an integer importance to a priority value. Lower is more important. */
const weightPriority = (prio) => ({ highest: 10, high: 20, medium: 30, low: 40, lowest: 50 }[prio] || prio)

/** Generates a simple sorting function that uses multiple keys. */
const sortGen = keys => data => data.sort((a, b) => {
  for (key of keys) {
    if (a[key] > b[key]) return 1
    if (a[key] < b[key]) return -1
    continue
  }
  return 0
})

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

  // Sorting function that takes several types of Jira data into account.
  const sorter = sortGen(['statusWeight', 'priorityWeight', 'key'])

  const data = sorter(preprocessJiraData(rawData))

  // List the largest items for each key, which we'll use as size for that column
  const largest = {
    key: findLargest('key', data),
    priority: findLargest('priority', data),
    statusNice: findLargest('statusNice', data),
    assignee: findLargest('assignee', data) // Currently unused.
  }

  // Iterate over the data to print it line by line.
  data.forEach(item => {
    const isChild = item.parent
    const summaryLength = cols - 2 - 2 - largest.key - 2 - largest.statusNice - 2
    const priorityArrow = priorityIcon(item.priority) // priorityIcon(['highest', 'high', 'medium', 'low', 'lowest'][Math.round(Math.random() * 4)])
    const taskItem = taskIcon(item.type) // taskIcon(['Sub-task', 'Task', 'Bug', 'Epic', 'Story'][Math.round(Math.random() * 4)])

    console.log([
      // Task icon
      ' ',
      taskItem,
      // Key, e.g. 'KMK-5'
      ' ',
      item.key,
      ' '.repeat(largest.key - item.key.length + 1),
      // Priority icon
      priorityArrow,
      // Summary (cropped to max. length)
      ' ',
      (item.summary + ' '.repeat(summaryLength)).slice(0, summaryLength),
      // Status
      ' ',
      item.statusNice,
      color.reset,
    ].join(''))
  })
}

main()
