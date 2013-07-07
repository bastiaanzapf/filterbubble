#!/bin/bash

cd script
./console production < train
./console production < update
./console production < classify
