#!/usr/bin/python3
import argparse
import os
import re
import shutil
import sys

class CleanBackups:
  def __init__(self):
    # Create a regular expression pattern to extract parameters from the
    # timestamps in the backup names.
    self.backupPattern = re.compile(
        r'(\d{2})(\d{2})(\d{2})-(\d{2})(\d{2})(\d{2})')

    # Initialize lists for backups to keep
    self.every = []
    self.yearly = []
    self.monthly = []
    self.daily = []

    # Clean up the backups:
    self.parseArgs()
    
    if not self.delete:
      self.output("This run will not delete anything as the --delete " + \
          "parameter is not given")

    self.retrieveFileLists()
    self.classifyBackups()
    self.deleteBackups()
    self.deleteLogs()

  def retrieveFileLists(self):
    self.backups = os.listdir(os.path.join(self.path, 'snapshots'))
    self.backups.sort()
    self.logs = os.listdir(os.path.join(self.path, 'logfiles'))
    self.logs.sort()

  def parseArgs(self):
    parser = argparse.ArgumentParser(
        description='Clean up old snapshot based backups to save diskspace.')
    
    parser.add_argument('path', help='The path where the backups are stored.' + \
        'This folder needs to contain the folders "snapshots" and "logfiles"')
    parser.add_argument('-y', '--years', action='store', type=int, default=5,
        help='For how many years should the yearly be stored? (default = 5)')
    parser.add_argument('-m', '--months', action='store', type=int, default=24,
        help='For how many months should the monthly backups be stored?' +
        '(default = 24)')
    parser.add_argument('-d', '--days', action='store', type=int, default=60,
        help='For how many days should the daily backup be stored? ' +
        '(default = 60)')
    parser.add_argument('-l', '--last', action='store', type=int, default=100,
        help='How many of the last backups should unconditionally be stored? ' +
        '(default = 100)')
    parser.add_argument('--silent', action='store_true',
        help='Suppress all output to STDOUT.')
    parser.add_argument('--delete', action='store_true',
        help='Actually delete the backups/logfiles which should not be kept.')
    
    self.args = parser.parse_args()
    self.path = self.args.path
    self.years = self.args.years
    self.months = self.args.months
    self.days = self.args.days
    self.last = self.args.last
    self.silent = self.args.silent
    self.delete = self.args.delete
  
  def classifyBackups(self):
    lastYear = None
    lastMonth = None
    lastDay = None

    for backup in self.backups:
      match = self.backupPattern.match(backup)
      if(match):
        year, month, day, hour, minute, second = match.groups()
        self.every.append(backup)
    
        if(lastDay != "%s%s%s" % (year, month, day)):
          lastDay = "%s%s%s" % (year, month, day)
          self.daily.append(backup)
    
        if(lastMonth != "%s%s" % (year, month)):
          lastMonth = "%s%s" % (year, month)
          self.monthly.append(backup)
    
        if(lastYear != year):
          lastYear = year
          self.yearly.append(backup)

    # Keep the last N from each list.
    self.every = self.every[-self.last:]
    self.yearly = self.yearly[-self.years:]
    self.monthly = self.monthly[-self.months:]
    self.daily = self.daily[-self.days:]

    # Create a single list over the backups to keep
    self.keep = [ backup for backup in self.backups if backup in self.every or \
        backup in self.daily or backup in self.monthly or \
        backup in self.yearly ]

  def deleteBackups(self):
    for backup in self.backups:
      if backup not in self.keep:
        self.output("%s should be DELETED" % backup)
        if self.delete:
          shutil.rmtree(os.path.join(self.path, "snapshots" , backup))
          self.output("%s is now DELETED" % backup)
      else:
        self.output("%s is kept" % backup)
    
  def deleteLogs(self):
    for log in self.logs:
      match = self.backupPattern.match(log)
      if match.group(0) not in self.keep:
        self.output("%s should be DELETED" % log)
        if self.delete:
          os.unlink(os.path.join(self.path, "logfiles", log))
          self.output("%s is now DELETED" % log)
      else:
        self.output("%s is kept" % log)

  def output(self, text):
    if(not self.silent):
      print(text)

if __name__ == "__main__":
  cleanBackups = CleanBackups() 
  sys.exit(0)
