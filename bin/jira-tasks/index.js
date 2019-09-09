#!/usr/bin/env node

// jira-tasks - Prints Jira task information scraped by ms-jira-cli
// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>
//
// In progress items are sorted to the top, then todo items, then done items.

const { homedir } = require('os')

const { makeTable } = require('./table')
const { makeProjectInfo } = require('./projects')
const { makeContribsInfo } = require('./contribs')
const { error } = require('./helpers')
const { getJiraData, getLayout, getContribsData, getTermData } = require('./data')

// Extra cache files (on top of the cache built into the cli apps).
const cachePathJira = `${homedir()}/.cache/dada/jira.json`
const cachePathGithub = `${homedir()}/.cache/dada/github.json`

/** Main script entry point. */
const main = (cacheFileJira, cacheFileGithub) => {
  try {
    const jiraData = getJiraData(cacheFileJira)
    const termData = getTermData()
    const contribsData = getContribsData(cacheFileGithub)
    const tableLayout = getLayout()

    const tableRows = makeTable(jiraData, termData.cols, tableLayout, undefined, false)
    const projectRows = makeProjectInfo(Object.values(jiraData.projects), termData.cols)
    const contribsRows = makeContribsInfo(contribsData.contributions, termData.cols)

    console.log()
    console.log(tableRows.join('\n'))
    console.log()
    console.log(projectRows.join('\n'))
    console.log()
    console.log(contribsRows.join('\n'))
    console.log()
  }
  catch (err) {
    error('an error occurred while building the tasks table:\n' + err.stack)
  }
}

main(cachePathJira, cachePathGithub)
