#!/usr/bin/env node

// jira-tasks - Prints Jira task information scraped by ms-jira-cli
// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>
//
// This command lists projects defined in Jira, and displays the user's
// Github contributions of the last year.

const { homedir } = require('os')

const { makeProjectInfo } = require('./util/projects')
const { makeContribsInfo } = require('./util/contribs')
const { error } = require('./util/helpers')
const { getJiraData, getContribsData, getTermData } = require('./util/data')

// Extra cache files (on top of the cache built into the cli apps).
const cachePathJira = `${homedir()}/.cache/dada/jira.json`
const cachePathGithub = `${homedir()}/.cache/dada/github.json`

/** Main script entry point. */
const main = (cacheFileJira, cacheFileGithub) => {
  const hardRefresh = ~process.argv.indexOf('--refresh')
  try {
    const jiraData = getJiraData(cacheFileJira, hardRefresh)
    const termData = getTermData()
    const contribsData = getContribsData(cacheFileGithub)

    const projectRows = makeProjectInfo(Object.values(jiraData.projects), termData.cols)
    const contribsRows = makeContribsInfo(contribsData.contributions, termData.cols)

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
