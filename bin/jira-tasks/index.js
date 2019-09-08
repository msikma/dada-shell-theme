#!/usr/bin/env node

// jira-tasks - Prints Jira task information scraped by ms-jira-cli
// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>
//
// In progress items are sorted to the top, then todo items, then done items.

const { homedir } = require('os')

const { makeTable } = require('./table')
const { makeProjectInfo } = require('./projects')
const { error } = require('./helpers')
const { getJiraData, getLayout, getTermData } = require('./data')

// Set the path to the user's Jira tasks cache.
const cachePath = `${homedir()}/.cache/dada/jira.json`

/** Main script entry point. */
const main = (cacheFile) => {
  try {
    const jiraData = getJiraData(cacheFile)
    const termData = getTermData()
    const tableLayout = getLayout()

    const tableRows = makeTable(jiraData, termData.cols, tableLayout, undefined, false)
    //const projectRows = makeProjectInfo(Object.values(jiraData.projects), termData.cols)

    console.log()
    console.log(tableRows.join('\n'))
    //console.log(projectRows.join('\n'))
    console.log()
  }
  catch (err) {
    error('an error occurred while building the tasks table:\n' + err.stack)
  }
}

main(cachePath)
