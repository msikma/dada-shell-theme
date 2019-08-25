#!/usr/bin/env node

// jira-tasks - Prints Jira task information scraped by ms-jira-cli
// MIT license © 2018-2019, Michiel Sikma <michiel@sikma.org>
//
// In progress items are sorted to the top, then todo items, then done items.

const process = require('process')
const { execSync } = require('child_process')
const { existsSync, readFileSync } = require('fs')
const { homedir } = require('os')

const { makeTable } = require('./table')
const { error } = require('./helpers')
const { getJiraData } = require('./data')

// Set the path to the user's Jira tasks cache.
const cachePath = `${homedir()}/.cache/dada/jira.json`

/** Main script entry point. */
const main = (cache) => {
  const jiraData = getJiraData(cache)
  
}

main(cachePath)
