// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>

const process = require('process')
const { execSync } = require('child_process')
const { existsSync, readFileSync } = require('fs')
const { error } = require('./helpers')

/** Standard layout for tasks tables. */
const getLayout = (args) => {
  // TODO: 'args' is currently unused.
  return {
    cols: ['type', 'key', 'priority', 'summary', 'status', 'link'],
    colDynamic: 'summary'
  }
}

/**
 * Returns Jira info in JSON format using the ms-jira-cli program.
 *
 * Returned data contains the following (with an example):
 *   - key      'KMK-26'
 *   - type     'Task'
 *   - summary  'Rewrite Pokesprite in JS'
 *   - link     'http://jira.theorycraft.fi/browse/KMK-26'
 *   - priority 'high'
 *   - status   'in_progress'
 *   - assignee 'Michiel Sikma'
 *   - parent   null
 *
 * The 'parent' value will be a string like 'key' if it's set, e.g. 'KMK-2'.
*/
const getJiraData = (path) => {
  try {
    if (existsSync(path)) {
      return JSON.parse(readFileSync(path))
    }
    const stdout = execSync('ms-jira-cli --action data --output json')
    const data = JSON.parse(stdout.toString('utf8'))
    return data
  }
  catch (err) {
    error('could not retrieve Jira info')
  }
}

/** Returns data about our current terminal. Only returns the width for now. */
const getTermData = () => {
  return {
    cols: process.stdout.columns
  }
}

module.exports = {
  getJiraData,
  getTermData,
  getLayout
}
