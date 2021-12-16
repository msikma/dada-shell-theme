#!/usr/bin/env node

const fs = require('fs').promises

const reformat = async (file, encoding = 'utf8') => {
  const data = JSON.parse(await fs.readFile(file, encoding))
  await fs.writeFile(file, JSON.stringify(data, null, 2) + '\n', encoding)
}

const reformatAll = async (files, encoding = 'utf8') => {
  for (const file of files) {
    await reformat(file, encoding)
  }
}

reformatAll(process.argv.slice(2))
