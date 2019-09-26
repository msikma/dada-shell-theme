// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>

const cjkLength = require('cjk-length').default

/** Helper function used for exiting the script. */
const error = reason => {
  console.log(`jira-list.js: error: ${reason}`)
  process.exit(1)
}

/** Returns a key from the colMappings if it's in there, or returns the input. */
const keyMap = (key, mappings) => (
  mappings[key] ? mappings[key] : key
)

/** Checks whether something is an array. */
const isArray = obj => obj instanceof Array

/** Find the largest item 'key' in an array of objects. */
const findLargest = (key, data) => data.reduce(((l, item) => {
  // Some items are an array of two items, of which only the first should be counted.
  // See e.g. the taskIcons and priorityIcons.
  const keyItem = (isArray(item[key]) ? item[key][0] : item[key]) || []
  return Math.max(keyItem.length, l)
}), 0)

/** Assigns an integer importance to a status value. Lower is more important. */
const weightStatus = (status) => ({ to_do: 20, in_progress: 10, done: 30 }[status] || status)

/** Assigns an integer importance to a priority value. Lower is more important. */
const weightPriority = (prio) => ({ highest: 10, high: 20, medium: 30, low: 40, lowest: 50 }[prio] || prio)

/** Crops and pads a string to a specific length. */
const hardPad = (str, len, padder = ' ') => {
  const regStrLength = str.length
  const cjkStrLength = cjkLength(str)
  return (str + padder.repeat(len)).slice(0, len - (cjkStrLength - regStrLength))
}

/** Generates a simple sorting function that uses multiple keys. */
const sortGen = keys => data => data.sort((a, b) => {
  for (key of keys) {
    if (a[key] > b[key]) return 1
    if (a[key] < b[key]) return -1
    continue
  }
  return 0
})

module.exports = {
  error,
  keyMap,
  findLargest,
  hardPad,
  isArray,
  sortGen,
  weightPriority,
  weightStatus
}
