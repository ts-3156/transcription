# -*- coding: utf-8 -*-
#
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# DO NOT EDIT! This is a generated sample ("LongRunningPromise",  "speech_transcribe_async_gcs")

# To install the latest published package dependency, execute the following:
#   pip install google-cloud-speech

# sample-metadata
#   title: Transcript Audio File using Long Running Operation (Cloud Storage) (LRO)
#   description: Transcribe long audio file from Cloud Storage using asynchronous speech
#     recognition
#   usage: python3 samples/v1/speech_transcribe_async_gcs.py [--storage_uri "gs://cloud-samples-data/speech/brooklyn_bridge.raw"]

# [START speech_transcribe_async_gcs]
from google.cloud import speech_v1
from google.cloud.speech_v1 import enums
import json


def sample_long_running_recognize(storage_uri):
    """
    Transcribe long audio file from Cloud Storage using asynchronous speech
    recognition

    Args:
      storage_uri URI for audio file in Cloud Storage, e.g. gs://[BUCKET]/[FILE]
    """

    client = speech_v1.SpeechClient()

    # storage_uri = 'gs://cloud-samples-data/speech/brooklyn_bridge.raw'

    # Sample rate in Hertz of the audio data sent
    sample_rate_hertz = 16000

    # The language of the supplied audio
    language_code = "ja-JP"

    # Encoding of audio data sent. This sample sets this explicitly.
    # This field is optional for FLAC and WAV audio formats.
    encoding = enums.RecognitionConfig.AudioEncoding.LINEAR16
    config = {
        "sample_rate_hertz": sample_rate_hertz,
        "language_code": language_code,
        "enable_word_time_offsets": True,
        "enable_automatic_punctuation": True,
        # "encoding": encoding,
    }
    audio = {"uri": storage_uri}

    operation = client.long_running_recognize(config, audio)

    # print(u"Waiting for operation to complete...")
    response = operation.result()
    output = {'results': []}

    for result in response.results:
        # First alternative is the most probable result
        alternative = result.alternatives[0]
        # print(u"Transcript: {}".format(alternative.transcript))

        words = []
        for word in alternative.words:
            start_time = word.start_time.seconds + word.start_time.nanos / 1_000_000_000.0
            end_time = word.end_time.seconds + word.end_time.nanos / 1_000_000_000.0
            word = word.word.split('|')[0]
            words.append({'word': word, 'start': start_time, 'end': end_time})
            # print(u"Word: {} {} {}".format(start_time, end_time, word))

        output['results'].append({'transcript': alternative.transcript, 'words': words})
    print(json.dumps(output))

# [END speech_transcribe_async_gcs]


def main():
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--storage_uri",
        type=str,
        default="gs://cloud-samples-data/speech/brooklyn_bridge.raw",
    )
    args = parser.parse_args()

    sample_long_running_recognize(args.storage_uri)


if __name__ == "__main__":
    main()
