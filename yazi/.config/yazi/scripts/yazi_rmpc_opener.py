#!/usr/bin/env python3

import argparse
import logging
import sys
from enum import Enum

import sh

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)


class RmpcCommand(Enum):
    CLEAR = "clear"
    ADD = "add"
    PLAY = "play"


class RmpcClient:
    def replace_playlist(self, tracks):
        try:
            sh.rmpc(RmpcCommand.CLEAR.value)

            for track in tracks:
                sh.rmpc(RmpcCommand.ADD.value, track)

        except Exception as e:
            logging.error(f"Failed to replace playlist: {e}")
            sys.exit(1)

    def play(self):
        try:
            sh.rmpc(RmpcCommand.PLAY.value)
        except Exception as e:
            logging.error(f"Failed to start playback: {e}")
            sys.exit(1)


class RmpcApp:
    def __init__(self):
        self.client = RmpcClient()

    @staticmethod
    def parse_arguments():
        parser = argparse.ArgumentParser(
            description="Replace the MPD queue with the selected tracks and start playback."
        )
        parser.add_argument(
            "tracks",
            nargs="+",
            help="Tracks to load into the MPD playlist.",
        )
        return parser.parse_args()

    def run(self):
        args = self.parse_arguments()

        self.client.replace_playlist(args.tracks)
        self.client.play()


if __name__ == "__main__":
    RmpcApp().run()
