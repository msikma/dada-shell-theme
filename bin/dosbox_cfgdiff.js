#!/usr/bin/env node

const fs = require('fs').promises
const path = require('path')

/**
 * Returns the header section content of a line.
 * 
 * E.g. for [sdl], this returns "sdl". Null is returned if this is not a section header.
 */
const getHeaderText = line => line.match(/^\[(.+?)\]$/)

/**
 * Reads a file and returns it as lines, with unnecessary lines removed.
 */
const readToLines = async fn => {
  // Reads the file into lines and removes empty ones.
  const lines = (await fs.readFile(fn, 'utf8'))
    .trim()
    .split('\n')
    .map(l => l.trim())
    .filter(l => l !== '')

  // Index of the [autoexec] section, which we will ignore.
  const autoexecIdx = lines.findIndex(l => l.trim() === '[autoexec]')

  return lines.slice(0, autoexecIdx)
}

/**
 * Parses an array of config lines into a section structure.
 */
const parseSections = lines => {
  const sections = {}
  
  // Default to the "_" section. It should be empty (and thus not get printed)
  // but it's just in case there are additional options without a section at the top.
  let activeSection = '_'

  for (const l of lines) {
    if (l.startsWith('#')) {
      continue
    }
    const header = getHeaderText(l)
    if (header) {
      activeSection = header[1]
      sections[activeSection] = {}
      continue
    }
    const item = l.split('=').map(section => section.trim())
    sections[activeSection][item[0]] = item[1]
  }

  return sections
}

/**
 * Reads a config file and parses it into an object.
 */
const readConfig = async fn => {
  const lines = await readToLines(fn)
  return parseSections(lines)
}

/**
 * Returns all config values that are different from the default (base).
 * 
 * Takes a base config file containing all default values and a user config file,
 * both parsed into sections.
 */
const getConfigDiff = (baseConfig, userConfig) => {
  const diffConfig = {}
  for (const [section, data] of Object.entries(userConfig)) {
    const baseSection = baseConfig[section]
    if (!baseSection) continue
    diffConfig[section] = {}
    for (const [name, value] of Object.entries(data)) {
      const baseValue = baseSection[name]
      if (baseValue !== value) {
        diffConfig[section][name] = value
      }
    }
  }
  return diffConfig
}

/**
 * Converts a sections object into a new config file.
 */
const makeConfig = (sections, fileBase, fileUser) => {
  // Convert config sections into a .conf file.
  const buffer = []
  for (const [section, data] of Object.entries(sections)) {
    if (Object.values(data).length === 0) {
      continue
    }
    buffer.push(`\n[${section}]`)
    for (const [name, value] of Object.entries(data)) {
      buffer.push(`${name} = ${value}`)
    }
  }
  
  // Add a file header with some base information.
  const header = []
  header.push(`DOSBox config diff between "${path.basename(fileBase)}" and "${path.basename(fileUser)}"`)
  header.push(`Generated: ${new Date().toISOString()}`)
  
  return [
    header.map(l => `# ${l}`).join('\n').trim(),
    buffer.join('\n').trim()
  ].join('\n\n')
}

/**
 * Displays the program usage and exits.
 */
const exitUsage = code => {
  const fn = path.basename(process.argv[1])
  console.log(`usage: ${fn} dosbox-base-config.conf my-config.conf`)
  process.exit(code)
}

/**
 * Parses the user's command line arguments and returns the base and user config files.
 */
const parseArgv = argv => {
  if (argv[0] === '-h' || argv[0] === '--help') {
    return exitUsage(0)
  }
  if (argv.length !== 2) {
    return exitUsage(1)
  }
  return argv
}

/**
 * Main program.
 * 
 * Reads two config files and prints out the diff between them.
 */
const main = async () => {
  const [fileBase, fileUser] = parseArgv(process.argv.slice(2)) 
  const confBase = await readConfig(fileBase)
  const confUser = await readConfig(fileUser)
  
  const confDiff = getConfigDiff(confBase, confUser)
  const output = makeConfig(confDiff, fileBase, fileUser)
  console.log(output)
}

main()
