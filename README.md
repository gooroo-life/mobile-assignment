# Gooroo mobile test assignment

### Tasks

Write an app to visualize a process / combine flow.
Process all the inputs and combine the top 10 outputs.

When launching the app, the user will enter the number of integer to process / combine (< 100) and generate an array of integers, to keep it simple, you can just use something like below and please modify the syntax accordingly based on the language which you're using:
```
values = []
for(i = 0; i < 100; i++) {
   values[i] = i
}
```

Then the user will go to the process / combine view that will display the process / combine flow for the input generated previously.

The UITableView/UICollectionView(iOS) or ListView(Android) will show the list of integers to process (generated in the previous page) and start processing the inputs and update the UITableViewCell/UICollectionViewCell/ListItemView to show the processed input's value. In order to process the input, please make a GET request call to 
https://exorciser-chatbot.herokuapp.com/process?input="your_value"

For example:
https://exorciser-chatbot.herokuapp.com/process?input=1

The response will be in json format
``` 
{
    "processed_value": 1627323074.855257,
    "value": "1"
}
```

A cell/list item view that is not yet processed will just show the integer, a cell/list item view that is processed will show the **value **and** processed_value** in the cell/ list item view.

The order of the cells/list item views in the table view / list view is:
- The processed cells/list item views (**sorted by processed_value descending**), followed by
- The unprocessed cells/list item views

Only the top 10 cells will be combined into a final result so these cells should have a visual cue (bold text or different color for instance).

When all the integers are processed, combine the top 10 processed_values by making a POST request to
https://exorciser-chatbot.herokuapp.com/combine

with a list of processed_value as body in json format

For example
``` 
{
	"input": [162, 257, 230, 74, 57, 99, 102, 140, 150, 160]
}
```

The response will be in json format as well
``` 
{
    "combined_result": "Q4BPWWL1DL",
    "input": [
        162,
        257,
        230,
        74,
        57,
        99,
        102,
        140,
        150,
        160
    ]
}
```


### Requirements
- Create the project with XCode/Android Studio
- The code should be written in Objective-C, Swift for iOS and Java, Kotlin for Android
- For the UI, iOS **do not use** Storyboards or NIB/XIB, just code; Android doesn't have any limitation.
- Due to some kind of limitation, we assume the app/server side can only process up to **5 integers at the same time**; therefore, you need to limit the number of parallel requests.
- If you have a personal helper, feel free to use it, but **don't use any other 3rd party**.
- Follow the standard **Git** procedures to branch off the master branch, as well as create a PR when it's ready
- Maintain the PR in a smaller size (remove unrelated, local, and auto generated files) in order to make it easier to review
- Git practices, PR readability, architecture + design, concise code, and logic will be taken into consideration
- UI design (i.e. whether the app is pretty or not) is not important (not taken into consideration).  UX / Useability is.
