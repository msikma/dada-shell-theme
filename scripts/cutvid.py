#!/usr/bin/env python3

import asyncio
import argparse

async def run_ffmpeg_cmd(cmd):
  proc = await asyncio.create_subprocess_exec(*cmd)
  code = await proc.wait()
  cmd_str = ' '.join(cmd)
  if (code == 0):
    print('\ncutvid: done, using the following command:\n{}\n'.format(cmd_str))
  if (code != 0):
    print('\ncutvid: ffmpeg finished with non-zero exit status ({}), using the following command:\n{}\n'.format(code, cmd_str))

def ffmpeg_cmd(in_file, out_file, start, duration, encode, copy, overwrite):
  '''Converts our command line arguments to a ffmpeg command.'''
  cmd = ['ffmpeg']
  if (overwrite):
    cmd.append('-y')
  if (start):
    cmd.extend(['-ss', '{}'.format(start)])
  if (duration):
    cmd.extend(['-t', '{}'.format(duration)])
  if (in_file):
    cmd.extend(['-i', '{}'.format(in_file)])
  if (copy):
    cmd.extend(['-c', 'copy'])
  if (encode):
    # Do nothing; converts as H.264 (libx264 in yuv420p colorspace) and AAC by default.
    pass
  if (out_file):
    cmd.append(out_file)
  return cmd

def run_cut(in_file, out_file, start, duration, encode, copy, overwrite):
  '''Runs ffmpeg to perform the video cutting operation.'''
  cmd = ffmpeg_cmd(**locals())
  print('cutvid: running ffmpeg.')
  print('')
  loop = asyncio.get_event_loop()
  loop.run_until_complete(asyncio.ensure_future(run_ffmpeg_cmd(cmd)))
  loop.close()

def main():
  '''Main entry point. Parses command line arguments and runs the cutting code.'''
  parser = argparse.ArgumentParser(prog='cutvid', description='Simple frontend for performing common ffmpeg operations')

  parser.add_argument('in_file', type=str, help='input file path')
  parser.add_argument('out_file', type=str, help='output file path')
  parser.add_argument('-s', dest='start', metavar='START', type=str, help='indicates time position to start from')
  parser.add_argument('-d', dest='duration', metavar='DURATION', type=str, help='indicates how long the cut should take')
  parser.add_argument('-e', dest='encode', action='store_true', help='re-encodes the video and audio streams', default=True)
  parser.add_argument('-c', dest='copy', action='store_true', help='copies the source video and audio streams (default)', default=True)
  parser.add_argument('-y', dest='overwrite', action='store_true', help='always overwrites the destination file (default)', default=True)

  args = vars(parser.parse_args())

  run_cut(**args)

main()
