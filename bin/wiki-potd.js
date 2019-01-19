#!/usr/bin/env node
const fs = require('fs')
const request = require('request')
const cheerio = require('cheerio')
const feedparser = require('feedparser-promised')
const exiftool = require('node-exiftool')
const exiftoolBin = require('dist-exiftool')
const sanitize = require('sanitize-filename')

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

// Downloads a file from a URL and saves it as a local file.
// Calls the given callback when done.
const downloadFile = (url, dest, cb) => {
  const file = fs.createWriteStream(dest)
  const sendReq = request.get(encodeURI(url))
  sendReq.on('response', (response) => {
    if (response.statusCode !== 200) {
      return cb('Response status was ' + response.statusCode)
    }
    sendReq.pipe(file)
  })
  sendReq.on('error', (err) => {
    fs.unlinkSync(dest)
    return cb(err.message)
  })
  file.on('finish', () => file.close(cb))
  file.on('error', (err) => {
    fs.unlinkSync(dest)
    return cb(err.message)
  })
}

// Checks whether the save path exists, and whether we're able to write to it.
const canSaveToPath = (path) => {
  const dirExists = fs.existsSync(path)
  if (!dirExists) process.exit(1)
  try {
    fs.accessSync(path, fs.constants.W_OK)
  }
  catch (err) {
    process.exit(1)
  }
}

// Check if we are able to save.
canSaveToPath(imgPath)

feedparser.parse(atomURL)
  .then(items => items.some(item => {
    const itemDate = new Date(item.pubDate).toISOString().slice(0, 10)
    if (itemDate !== today) return false

    const $ = cheerio.load(item.description)
    const imgRaw = $('img').attr('src')
    const img = decodeURI(thumbToFullURL(imgRaw))
    const imgFn = sanitize(`${today}_${img.split('/').slice(-1)}`)
    const desc = $('div[lang=en].description').text().trim()
    const hrDay = new Intl.DateTimeFormat('en-US', { month: 'long', day: 'numeric' }).format(item.pubDate)
    const imgFnPath = `${imgPath}/${imgFn}`

    // Check if file has already been downloaded before.
    if (fs.existsSync(imgFnPath)) {
      process.exit(0)
    }

    console.log()
    console.log(`${color.fgYellow}Wikimedia Commons picture of the day for ${color.fgGreen}${hrDay}${color.reset}`)
    console.log()

    console.log(`${color.fgMagenta}Remote image: ${color.fgCyan}${img}`)
    console.log(`${color.fgMagenta}   Saving as: ${color.fgCyan}${imgFn}${color.reset}`)
    console.log(`${color.fgMagenta} Description: ${color.fgBlue}${desc}${color.reset}`)
    console.log()

    downloadFile(img, imgFnPath, () => {
      // Write the description as metadata.
      ep.open().then(() => ep.writeMetadata(imgFnPath, {
        all: '',
        comment: desc
      }, ['overwrite_original', 'codedcharacterset=utf8']))
      .then(() => console.log('Added description as EXIF tag.'), (res) => console.error(res))
      .then(() => ep.close())
      .catch((res) => console.error(res))

      console.log('File saved.')
    })
  }))
  .catch(err => console.error(`wiki-potd.js: error: ${err.toString()}`));
