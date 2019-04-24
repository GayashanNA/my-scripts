import csv
import matplotlib.pyplot as plt
import time

PLOT_PER_WINDOW = False
WINDOW_LENGTH = 60000
BINS = 1000
delay_store = {}
perwindow_delay_store = {}
plotting_delay_store = {}

filename = "output-large.csv"
# filename = "output.csv"
# filename = "output-medium.csv"
# filename = "output-small.csv"
# filename = "output-tiny.csv"

with open(filename, "rU") as dataFile:
    csvreader = csv.reader(dataFile)
    for row in csvreader:
        if len(row) > 2 and str(row[0]).isdigit():
            delay_store[long(row[1])] = long(row[2])

window_begin = min(delay_store.keys())
window_end = max(delay_store.keys())

if PLOT_PER_WINDOW:
    window_end = window_begin + WINDOW_LENGTH
    # find the time delays that are within the window of choice
    for (tapp, delay) in delay_store.iteritems():
        if window_begin <= tapp <= window_end:
            perwindow_delay_store[tapp] = delay
    plotting_delay_store = perwindow_delay_store
else:
    plotting_delay_store = delay_store

# the histogram of the data
n, bins, patches = plt.hist(plotting_delay_store.values(), BINS, histtype='stepfilled',
                            normed=True, cumulative=False, facecolor='blue', alpha=0.9)
# plt.axhline(y=0.95, color='red', label='0.95')

max_delay = max(plotting_delay_store.values())
min_delay = min(plotting_delay_store.values())
count = len(plotting_delay_store.values())
# format epoch time to date time to be shown in the plot figure
window_begin_in_datetime = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(window_begin / 1000))
window_end_in_datetime = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(window_end / 1000))

title = "Window begin: %s\n" % window_begin_in_datetime
title += "Window end: %s\n" % window_end_in_datetime
# title += "Window length: %dms\n" % WINDOW_LENGTH
title += "Window length: ~%dmins\n" % ((window_end - window_begin)/60000)
title += "Maximum delay: %dms\n" % max_delay
title += "Minimum delay: %dms\n" % min_delay
title += "Count: %d" % count

# start plotting
plt.xlabel('Delay (ms)')
plt.ylabel('Probability')
plt.grid(True)
plt.legend()
plt.suptitle(title)
plt.subplots_adjust(top=0.8)
plt.show()
