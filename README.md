# Overview

Implementation of simple task with ruby and redis.

# Usage
To start normal consumer/generator run:
```
ruby redisq.rb
```
To get errors queue run:
```
ruby redisq.rb --errors
```

# Task

Script should generate and consume messsages from redis. One instanse can be either generator or consumer. When generator dies any of consumers should become generator. 15% of messages go to error queue. Scripts should be able to handle any number of consumers.

# Why?

Just 4 lulz.

# TODO

Tests with rspec.
