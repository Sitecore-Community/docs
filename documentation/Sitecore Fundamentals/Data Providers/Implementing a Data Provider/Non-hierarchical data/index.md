---
layout: default
title: Implementing Sitecore Data Providers for Non-Hierarchical Data
---
Sitecore data providers expect that data can be organized hierarchically, with each item having one - and only one - parent. 

In the real-world, however, not all data fits into this patterns. For example, in a product information management (PIM) system a product may be located in multiple categories. In this case the product doesn't have a single parent.

Data providers can accommodate non-hierarchical data, but this sort of data must be handled in a specific way.

