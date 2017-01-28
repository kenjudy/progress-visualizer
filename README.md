progress-visualizer
==============

# About Progress Visualizer

This is a project built in Ruby on Rails to track and report activity in trello boards as a burn up.

When I built it in 2013, I couldn't find an affordable alternative that did what I wanted which was track a board in near real time using the Trello API.

Now there are alternatives and I no longer work in Rails so I am no longer maintaining the codebase.

## Quickly setup visual reporting for your Trello boards

Trello offers simplicity and openness. It doesn't impose unnecessary assumptions. It offers an API that lets you interact with your data and webhooks which allow you to do so in near real time. I've tried to follow Trello's lead and make <strong>ProgressVisualizer</strong> just as easy.

## Available Visualizations

I wrote ProgressVisualizer to make my team's work visible to our dev, product and executive sponsors. This includes:

* showing progress in the current week
* comparing the amount of work completed over a three week period (yesterday's weather)
* showing the amount of work completed in the current rolling quarter
* listing work completed
* a dashboard/report containing all of these except the burnup suitable for sharing with management.

## Simple Setup

ProgressVisualizer only assumes that:

* you organize work in cards on a Trello Board, and
* you organize those cards into lists representing to do's and done work.

With that, you have all the data required for the charts and reports provided by ProgressVisualizer.

## Optional Tracking Features

### Iterations

That said, ProgressVisualizer will be more helpful if you work in fixed regular iterations (one, two, three or four weeks) and archive or otherwise move cards out of your done list(s) at the end of those iterations.

### Estimates

If you estimate work using the Scrum for Trello convention -- numbers in parentheses in front of the titles of your cards -- ProgressVisualizer will report those estimates on the burn up, long term trend chart and the done work table

### Classification of work

If you classify work using Trello labels, these types of work can be broken out on the yesterday's weather stacked bar chart and the done work table. For example, my team distinguished between work planned for the week, inserted into the backlog mid-iteration, or pulled in to fill slack.
