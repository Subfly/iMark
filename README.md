# Intro Course Project App of Ali Taha Dinçer for the iPraktikum

To pass the intro course, you need to create your own unique iOS app (based on SwiftUI).

There are no requirements regarding the functions of your app, so you can get creative.
However, we provide you with Non-Functional Requirements (NFR) that your app needs to fulfill.

After each day of learning new Swift and SwiftUI concepts, these NFRs may change, or new NFRs get added.

## Submission procedure

You get a **personal repository** on Gitlab to work on your app.

Once you implemented a new feature into your app, you need to create a Merge Request (MR - Sometimes we will also reference these as "Pull Requests"(PR)) to merge your changes from the feature branch into your main branch.

Your tutor will review your changes and either request changes or approves the MR.

If your MR got approved, you also need to merge it!

### Deadline: **15.10.2024 23:59**

Until the deadline all of your PRs **need to be merged** and your final app **needs to fulfill** all of the requested NFRs!

---

## Problem Statement (max. 500 words)

Every platform has its own bookmarking system but has limited capabilities. For example, X (formerly Twitter) requires users to have premium membership in order to do categorization, and Instagram only let users to save the posts without labeling or giving a unique identification for them. People struggle to find the saved posts or links  form the internet later on everyday in their life. In order to solve this Yaba (Yet Another Bookmark App) is here, where users can save any link, post or tweet by labeling and/or tagging them, and then, search them easily.

## Requirements

### Functional

- Users can save any type of link by providing a label to it.
- Users can create their own folders for easier categorization.
- Users can create tags for easier categorization.
- Users can save links to folder, in order to easily categorize them.
- Users can add how many tags they want to a bookmark, as well as remove any tag.
- Users can search their bookmarks by their label or description.
- Users can be move their bookmarks to any other folder.

### Nonfunctional

- Users should see the unfurled version of their saved content. 
- Unfurling the link should be lazily in order to preserve data usage.
- All bookmarks should be saved on device locally.

## Analysis

![Analysis Design](./assets/analysis_diagram.svg) 

## System Design

![System Design](./assets/system_design.svg) 

## Product Backlog

| Code    | Requirement                            | Severity       | Progress    |
|---------|--:-:-----------------------------------|--:-------------|--:----------|
| YABA-1  | Add folder creation                    | Vert Important | Not Started |
| YABA-2  | Add tag creation                       | Very Important | Not Started |
| YABA-3  | Add bookmark creation                  | Very Important | Not Started |
| YABA-4  | Add bookmark and folder detail screens | Very Important | Not Started |
| YABA-5  | Add bookmark search                    | Very Important | Not Started |
| YABA-6  | Add create bookmark from share modal   | Very Important | Not Started |
| YABA-7  | Add link previews                      | Important      | Not Started |
| YABA-8  | Add folder colors                      | Nice to have   | Not Started |
| YABA-9  | Add tag colors                         | Nice to have   | Not Started |
| YABA-10 | Add move bookmark to another folder    | Nice to have   | Not Started |
