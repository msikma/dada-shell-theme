#!/usr/bin/env node
const fs = require('fs')
const cheerio = require('cheerio')
const feedparser = require('feedparser-promised')
const exiftool = require('node-exiftool')
const exiftoolBin = require('dist-exiftool')

// Path to where we'll store the images, without trailing slash.
// If this doesn't exist we'll silently fail.
const imgPath = `/Users/msikma/Files/Pictures/Collections/Picture of the Day`

// Load the picture of the day feed.
// <https://commons.wikimedia.org/w/api.php?action=featuredfeed&feed=potd&feedformat=rss&language=en>
const atomArgs = ['action=featuredfeed', 'feed=potd', 'feedformat=rss', 'language=en'].join('&')
const atomURL = `https://commons.wikimedia.org/w/api.php?${atomArgs}`

// Set up exiftool process.
const ep = new exiftool.ExiftoolProcess(exiftoolBin)

// Terminal color escape codes
// <https://stackoverflow.com/a/41407246>
const color = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  dim: '\x1b[2m',

  fgRed: '\x1b[31m',
  fgGreen: '\x1b[32m',
  fgYellow: '\x1b[33m',
  fgBlue: '\x1b[34m',
  fgMagenta: '\x1b[35m',
  fgCyan: '\x1b[36m',

  bgRed: '\x1b[41m',
  bgGreen: '\x1b[42m',
  bgYellow: '\x1b[43m',
  bgBlue: '\x1b[44m',
  bgMagenta: '\x1b[45m',
  bgCyan: '\x1b[46m'
}

// E.g. '2018-11-24'.
const today = new Date().toISOString().slice(0, 10)

// Turns a Wikipedia thumbnail URL into a full size image URL.
const thumbToFullURL = thumbURL => {
  // Remove 'thumb/' segment to get full size.
  const noThumb = thumbURL.replace('wikipedia/commons/thumb', 'wikipedia/commons')
  const parsed = new URL(noThumb)
  // Remove the size indicator by matching it.
  const bits = parsed.pathname.match(/(^.+?\.[a-z]{3,4})(.+?$)/, '')
  parsed.pathname = bits ? bits[1] : parsed.pathname;

  return String(parsed);
}

// Checks whether the save path exists, and whether we're able to write to it.
const canSaveToPath = () => {
  const dirExists = fs.existsSync(imgPath)
  if (!dirExists) process.exit(1)
  try {
    fs.accessSync(imgPath, fs.constants.W_OK)
  }
  catch (err) {
    process.exit(1)
  }
}

// Check if we are able to save.
canSaveToPath()

feedparser.parse(atomURL)
  .then(items => items.some(item => {
    const itemDate = new Date(item.pubDate).toISOString().slice(0, 10)
    if (itemDate !== today) return false

    const $ = cheerio.load(item.description)
    const img = thumbToFullURL(decodeURIComponent($('img').attr('src')))
    const imgFn = `${today}_${img.split('/').slice(-1)}`
    const desc = $('div[lang=en].description').text()
    const hrDay = new Intl.DateTimeFormat('en-US', { month: 'long', day: 'numeric' }).format(item.pubDate)

    console.log()
    console.log(`${color.fgYellow}Wikimedia Commons picture of the day for ${color.fgGreen}${hrDay}${color.reset}`)
    console.log()

    console.log(`${color.fgMagenta}Image: ${color.fgCyan}${img}`)
    console.log(`${color.fgMagenta}Desc.: ${color.fgBlue}${desc}${color.reset}`)
    console.log(`${color.fgMagenta}   Fn: ${color.fgGreen}${imgFn}${color.reset}`)

    // Attach the description as Exif comment.
    ep.open().then(() => ep.writeMetadata('test.jpg', {
      all: '',
      comment: 'Exiftool rules!'
    }, ['overwrite_original']))
    .then(console.log, console.error)
    .then(() => ep.close())
    .catch(console.error);

    ep
      .open()
      // include only some tags
      .then(() => ep.readMetadata('test.jpg', ['comment', 'CreatorWorkURL', 'Orientation']))
      .then(console.log, console.error)
      .then(() => ep.close())
      .catch(console.error)

  }))
  .catch(err => console.error(`wiki-potd.js: error: ${err.toString()}`));
