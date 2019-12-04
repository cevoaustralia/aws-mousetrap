# AWS Mousetrap

## The concept

This repo contains an implementation of a concept I came up with a few years ago, but haven't started working on until recently.
The famous board game [Mousetrap](https://en.wikipedia.org/wiki/Mouse_Trap_(game)) asks you to build a [Rube
Goldberg](https://en.wikipedia.org/wiki/Rube_Goldberg_machine) machine or [Heath
Robinson](https://en.wikipedia.org/wiki/W._Heath_Robinson) contraption that will catch a nominal mouse by stringing together a
huge, unweildy collection of machines and devices.

In the case of AWS Mousetrap, the goal is slightly different. There aren't any mice to catch, after all. Instead, the challenge
is this:

```
Send a 64-byte message using as many different AWS services as possible
```

That's it. The service you start from, the service you end up in are entirely up to you. The services you use in between the
input and output are entirely up to you.

## Rules

1. The goal is to use as many distinct services as possible. Using the same service multiple times only counts for 1 point (eg 5
   SNS topics is still only worth 1 point)
1. The message must be a 64-byte GUID generated outside the "mousetrap" and passed to the "input" service by some API call
1. The message must be consumed from the "output" service by an API call, and must be identical to the input message
1. The construction **must** by done through repeatable methods -- whether this is CloudFormation, Terraform, CDK, etc is up to
   you but non-AWS services don't count (eg Terraform doesn't count as a service)
1. The mousetrap **must** be able to be torn down / removed / deleted after the message has been "delivered" -- this is to ensure
   that good resource lifecycle practices are followed, and don't result in cost blowouts
1. Some services are excluded for reasons of cost or availability (see below)
1. Certain services score more highly than others (see below)
1. Maximum points wins

## Optional Constraints

In order to make the challenge more approachable, you could apply some optional constraints that could include (but aren't
limited to):

1. Time limit (eg 8 hours if part of a Hackathon or similar event)
1. Cost (eg only allowed to use services where the total spend will be less than US$10/day)
1. Regionality (eg you can only use a single specific region)

## Excluded Services

It's not reasonable to use certain services or offerings for this
challenge, often for reasons of cost, availability, lead time, or because
they impose a cost on third parties. Many excluded services are those
that require physical hardware to be involved

* Outposts
* Ground Station
* IoT GreenGrass
* Marketplace
* Support
* Managed Services
* Snowball

Of course, if you're doing this challenge as part of an IoT team, then
by all means choose to include the service in your implementation of
the challenge. I'm not the boss of you.

## Scoring

Most services score 1 point; some are more difficult to configure or use, especially in the context of this challenge, and score
more accordingly. To use certain other services in this way is quite perverse, and therefore using them successfully for this
challenge scores very highly.

| Service | Score |
|---------|-------|
| Default service score | 1 point |
| Workspaces | 30 points |
| Braket | 50 points |


