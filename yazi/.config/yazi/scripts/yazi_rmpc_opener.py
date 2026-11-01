#!/usr/bin/env python3

import argparse
import logging
import os
import sys

import sh

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.StreamHandler(sys.stderr),  # visible if you run manually
        logging.FileHandler("/tmp/yazi_rmpc.log"),  # always logged
    ],
)

# Force the same socket you configured in mpd.conf / rmpc
SOCKET = os.path.expanduser("~/.config/mpd/socket")


def rmpc(*args):
    """Always talk to the correct MPD instance."""
    return sh.rmpc("--address", SOCKET, *args)


class RmpcClient:
    def replace_playlist(self, tracks):
        try:
            logging.info(f"Clearing queue and adding {len(tracks)} tracks")
            rmpc("stop")
            rmpc("clear")

            for track in tracks:
                uri = f"file://{track}"
                logging.info(f"Adding: {uri}")
                rmpc("add", uri)

            logging.info("Playlist replaced successfully")
        except Exception as e:
            logging.error(f"Failed to replace playlist: {e}")
            sys.exit(1)

    def play(self):
        try:
            rmpc("play")
            logging.info("Playback started")
        except Exception as e:
            logging.error(f"Failed to start playback: {e}")
            sys.exit(1)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("tracks", nargs="+")
    args = parser.parse_args()

    client = RmpcClient()
    client.replace_playlist(args.tracks)
    client.play()


if __name__ == "__main__":
    main()
