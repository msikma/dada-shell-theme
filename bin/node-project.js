#!/usr/bin/env node

// Displays some basic information about the Node project in this directory.
// If there is no package.json in the directory, nothing will be output.

const { exec } = require('child_process')
const fs = require('fs')
if (!fs.existsSync(`${process.cwd()}/package.json`)) process.exit()
const isYarn = fs.existsSync(`${process.cwd()}/yarn.lock`)
const { name, description, version, homepage, bin, scripts } = require(`${process.cwd()}/package.json`)
const lernaVersion = fs.existsSync(`${process.cwd()}/lerna.json`)
  ? require(`${process.cwd()}/lerna.json`).version
  : ''
const leftSize = 18
const rightSize = process.stdout.columns - leftSize - 1

// List all Markdown files in the directory. Always sort readme.md on top.
const dirCont = fs.readdirSync(process.cwd())
const mdFiles = dirCont.filter((f) => /.*\.(md)/gi.test(f))
  .sort((a, b) => {
    if (a.toLowerCase() === 'readme.md') return -1
    if (b.toLowerCase() === 'readme.md') return 1
    return a > b
  })

// Calls an external program and returns the result.
const callExternal = (cmd) => (
  new Promise((resolve, reject) => {
    exec(cmd, (error, stdout = '', stderr = '') => {
      if (error) return reject(stdout.trim(), stderr.trim(), error)
      else resolve(stdout.trim(), stderr.trim())
    })
  })
)

// Get Git info.
Promise.all([
  // callExternal('git describe --all | sed s@heads/@@'),
  // callExternal('git rev-parse --short head'),
  // callExternal('git rev-parse head'),
  // callExternal('git rev-list head --count'),
  callExternal('git log -n 1 --date=iso8601 --pretty=format:%cd'),
  callExternal('git log -n 1 --date=relative --pretty=format:%cd')
])
.then(gitInfo => {
  const gitLine = `Last commit: ${gitInfo[0]} (${gitInfo[1]})`
  printInfo(gitLine);
})
.catch(_ => {
  printInfo()
})



const green = '[32m'
const normal = '[30m(B[m'
const red = '[31m'
const yellow = '[33m'
const cyan = '[36m'
const blue = '[34m'
const purple = '[35m'
const link = '[4m[34m'

// In case the project hasn't defined any.
const binObj = typeof bin === 'string' ? { [bin.split('/').slice(-1)[0]]: bin } : bin
const binItems = binObj ? binObj : {}
const scriptItems = scripts ? scripts : {}

// Limits the size of a string to a certain value and adds an ellipsis if shortened.
const limitSize = (str, size) => {
	if (str.length <= size) return str
	return str.slice(0, size - 1) + '…'
}
// Pads the size of a string to a certain value with spaces.
const padSize = (str, size) => {
  return str + ' '.repeat(Math.max(size - str.length, 0))
}

const printInfo = (gitLine) => {
  // Print the title, version and description.
  console.log('')
  console.log(`${red}${name}${normal} ${version || lernaVersion ? `${purple}(${version || lernaVersion})${normal} ` : ``}${homepage ? `${blue}<${link}${homepage}${normal}${blue}>${normal}` : ''}`)
  if (description) {
    console.log(`${green}${description}${normal}`)
  }
  if (gitLine) {
    console.log(`${yellow}${gitLine}${normal}`)
  }
  if (Object.keys(bin || {}).length > 0 || Object.keys(scripts || {}).length > 0) {
    console.log('')
  }

  // Find out which of the two is the longest - we'll use that many iterations.
  const binKeys = Object.keys(binItems).sort()
  const scriptKeys = Object.keys(scriptItems).sort()
  const iterate = Math.max(binKeys.length, scriptKeys.length)

  for (let n = 0; n < iterate; ++n) {
    const scriptName = scriptKeys[n]
      ? limitSize(scriptKeys[n], leftSize)
      : ' '.repeat(leftSize)
    const binName = binKeys[n]
      ? limitSize(binKeys[n], leftSize)
      : ' '.repeat(leftSize)
    const mdName = mdFiles[n]
      ? limitSize(mdFiles[n], leftSize)
      : ' '.repeat(leftSize)
    const scriptLabel = n === 0
      ? isYarn
        ? 'yarn run'
        : 'npm run'
      : isYarn
        ? '        '
        : '       '
    const binLabel = n === 0 && binKeys.length > 0
      ? 'bin'
      : '   '
    const mdLabel = n === 0 && mdFiles.length > 0
      ? 'doc'
      : '   '
    console.log([
      yellow,
      scriptLabel,
      ' ',
      blue,
      padSize(!scriptName.trim() && n === 0 ? '(none)' : scriptName, leftSize),
      ' ',
      yellow,
      binLabel,
      ' ',
      purple,
      padSize(!binName.trim() && n === 0 ? '(none)' : binName, leftSize),
      ' ',
      yellow,
      mdLabel,
      ' ',
      red,
      mdName,
      normal
    ].join(''))
  }

  console.log('')
}
