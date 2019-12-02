## Making a Project Website

### About

My name is Jake and I am a graduate student studying off-highway equipment.

<img src="HeadShot.jpg" width="200" height="200">

### Introduction to a research question (what is the background on this subject; why does the question matter; who will it help; how has been attempted to be answered)

My goal is to find what causes error in the stability of a boom by scrubbing through data of field running.

What kind of data is avialble?  How is your data collected?  Are there any concerns about the data?  Which data is the most relevant?  Is the data easy to acccess? Will the data change over time?  What needs to be done to the data to get it ready for any downstream analysis?

#### Paragraph on what my research is about and what I want to solve

* Add picture of field we are testing

* Add picture of boom desciritpion (POS Presentation YAW roll pitch)

#### Clear data analysis question 

* What is my research question, look back at paragrpah. This is will just be a big heading


#### Clear identification of data inputs

* Feature list with descriptions

##### Features

Center Frame Roll Rate Deere Sensor - 
Center Frame Roll Rate LVDT - A linear variable differential transformer reports the roll angle of the center frame in deg/sec
Cylinder Pressure - Max pressure of the tilt cylinders at a given time
Speed - Speed of the self propelled sprayer in km/h
Tilt Up Command - Speed commanded to raise the boom of the sprayer by the tilt cylidners [deg/sec]
Tilt Down Command - Speed commanded to lower the boom of the sprayer by the tilt cylidners [deg/sec]
State Condition - Whether the machine is starting/stopping, state 0, or running in the field, state 1
Inlet Pressure - System pressure of the machine
Chassis Pitch Rate - Rate at which the chassis of the self propelled sprayer pitches
Chassis Roll Angle - Angle at which the chassis of the self propelled sprayer rolls
Chassis Roll Rate - Rate at whcih the chassis of the self propelled sprayer rolls
Chassis Yaw Rate - Rate at whcih the chassis of the self propelled sprayer experiences yaw
Right Front Potentiometer - Linear distance the right front tire strokes in and out from the chassis
Left Front Potentiometer - Linear distance the left front tire strokes in and out from the chassis
Right Rear Potentiometer - Linear distance the right rear tire strokes in and out from the chassis
Left Rear Potentiometer - Linear distance the left rear tire strokes in and out from the chassis


#### Analysis Methods

### Project Workflow

Project Workflow:

![Project Workflow](ProjectWorkflow.png)

#### Matlab

* Add picture of matlab scripting

* Add picture of DownSample

* Add picture of if loop

* Add picture of if loop for Error (description)

* Add picture of data table

#### Python

* Pulling in dataset

* Heat Map correlation

* From heat map, this is a jointplot I created

* creating statistcal methods

*Create Random forest machine learning test dataset and training dataset

* Ranked decisions with explanation

*Features IMportance - Condition

* Decision Tree Picture from website

* Add if we take away speed condition with mask

* Add how I masked it

#### Pros and Cons of using Random Forest/Decison Tree

### Paragraph on topics below

Incorporation of topics relevant to this class  - what from the class did you use in this project and why might it be useful for research projects like this?  What are the advantages and disadvantages?  Were there any assumptions or transformations needed?

### Objectives
Why is there error?

### Repeatability

Ability to automate and reproduce your analysis (if the file input were to change, could this analysis be reproduced and how easily?)  - how will someone else reproduce this analysis?  Is the data stored somewhere?  Can I reproduce the figures easily?

* How do I automate this analysis
* Add steps

### Task for Class

* Task about CSV of Ramp and creating Decision Tree. How does this relate to the E-W runs

#### Other things I will look for:

* Inclusion of statistical tools

* Publication of workflow in a version controlled manner (your code should be on github)

* What did you learn and do the results make sense?  Revisit your initial question and answer it.  H



