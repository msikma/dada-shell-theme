#!/usr/bin/env node

// jira-tasks - Prints Jira task information scraped by ms-jira-cli
// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>
//
// Lists tasks defined in Jira.
// In progress items are sorted to the top, then todo items, then done items.

const { homedir } = require('os')

const { makeTable } = require('./util/table')
const { error } = require('./util/helpers')
const { getJiraData, getLayout, getTermData } = require('./util/data')

// Extra cache files (on top of the cache built into the cli apps).
const cachePathJira = `${homedir()}/.cache/dada/jira.json`
const cachePathGithub = `${homedir()}/.cache/dada/github.json`

/** Main script entry point. */
const main = (cacheFileJira, cacheFileGithub) => {
  const hardRefresh = ~process.argv.indexOf('--refresh')
  try {
    const jiraData = getJiraData(cacheFileJira, hardRefresh)
    const termData = getTermData()
    const tableLayout = getLayout()

    const tableRows = makeTable(jiraData, termData.cols, tableLayout, undefined, false)

    console.log()
    console.log(tableRows.join('\n'))
    console.log()
  }
  catch (err) {
    error('an error occurred while building the tasks table:\n' + err.stack)
  }
}

main(cachePathJira, cachePathGithub)
