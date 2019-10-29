// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>

const process = require('process')
const { execSync } = require('child_process')
const { existsSync, readFileSync, writeFileSync, unlinkSync } = require('fs')
const { error } = require('./helpers')

/** Standard layout for tasks tables. */
const getLayout = (args) => {
  // TODO: 'args' is currently unused.
  return {
    cols: ['type', 'key', 'priority', 'summary', 'status', 'link'],
    colDynamic: 'summary'
  }
}

const getCacheOrExec = (path, cmd, name, hardRefresh = false) => {
  try {
    if (existsSync(path) && !hardRefresh) {
      return JSON.parse(readFileSync(path))
    }
    const stdout = execSync(`ms-jira-cli ${hardRefresh ? '--no-cache' : ''} --action data --output json`)
    const data = JSON.parse(stdout.toString('utf8'))
    // Delete and rewrite the cached data.
    unlinkSync(path)
    writeFileSync(path, JSON.stringify(data), 'utf8')
    return data
  }
  catch (err) {
    error('could not retrieve Jira info (restore cookies and run with --refresh)')
  }
}

/**
 * Returns Github contributions data.
 *
 * The data has the following structure:
 *
 *   { contributions:
 *     { dates:
 *       '2018-09-09': { count: 6, color: '#c6e48b' },
 *       ... etc.
 *
 * The dates are always sorted ascending.
 */
const getContribsData = (path) => {
  return getCacheOrExec(path, 'Github', 'github-contribs-cli --action data --username msikma --output json')
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
 * If 'hardRefresh' is true, we will delete our own cache file and remake it.
*/
const getJiraData = (path, hardRefresh = false) => {
  return getCacheOrExec(path, 'Jira', 'ms-jira-cli --action data --output json', hardRefresh)
}

/** Returns data about our current terminal. Only returns the width for now. */
const getTermData = () => {
  return {
    cols: process.stdout.columns
  }
}

module.exports = {
  getJiraData,
  getContribsData,
  getTermData,
  getLayout
}
