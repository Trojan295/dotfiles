#!/usr/bin/env python3

import logging
import subprocess

import requests


logging.basicConfig(level=logging.INFO)
_log = logging.getLogger()

_session = requests.session()


def get_latest_github_release(owner, project):
    url = f'https://api.github.com/repos/{owner}/{project}/releases/latest'

    res = _session.get(url)
    res.raise_for_status()

    return res.json()


class VersionChecker:
    name = None

    def get_latest(self):
        raise NotImplementedError

    def get_current(self):
        raise NotImplementedError

    def check_version(self):
        latest = self.get_latest()
        current = self.get_current()
        if latest != current:
            _log.info(
                'There is a new version for %s. New: %s, current: %s',
                self.name, latest, current
            )


class PolybarChecker(VersionChecker):
    name = 'polybar'
    owner = 'jaagr'
    project = 'polybar'

    def get_latest(self):
        release = get_latest_github_release(self.owner, self.project)
        return release['name']

    def get_current(self):
        proc = subprocess.run(['polybar', '-v'], stdout=subprocess.PIPE)
        stdout = proc.stdout.decode()
        header = stdout.split()[1]
        return header


class i3GapsChecker(VersionChecker):
    name = 'i3-gaps'
    owner = 'Airblader'
    project = 'i3'

    def get_latest(self):
        release = get_latest_github_release(self.owner, self.project)
        return release['tag_name']

    def get_current(self):
        proc = subprocess.run(['i3', '-v'], stdout=subprocess.PIPE)
        stdout = proc.stdout.decode()
        header = stdout.split()[2].split('-')[0]
        return header


class AlacrittyChecker(VersionChecker):
    name = 'alacritty'
    owner = 'jwilm'
    project = 'alacritty'

    def get_latest(self):
        release = get_latest_github_release(self.owner, self.project)
        return release['tag_name'][1:]

    def get_current(self):
        proc = subprocess.run(['alacritty', '--version'], stdout=subprocess.PIPE)
        stdout = proc.stdout.decode()
        header = stdout.split()[1]
        return header


def main():
    apps = (
        PolybarChecker(),
        i3GapsChecker(),
        AlacrittyChecker()
    )

    for app in apps:
        app.check_version()


if __name__ == '__main__':
    main()
