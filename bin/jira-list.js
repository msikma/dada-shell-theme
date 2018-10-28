#!/usr/bin/env node

const { execSync, spawn, exec } = require('child_process')

const error = reason => {
  console.log(`jira-list.js: Error: ${reason}`)
  process.exit(1)
}

const stdout = execSync('jira-overview-cli --action list --output json')
const data = JSON.parse(stdout.toString('utf8'))

data.forEach(item => {
  console.log(item.key)
})
