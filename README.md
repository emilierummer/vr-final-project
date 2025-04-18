# Basic Information

This project involved creating a program to run on a VR headset. The program uses passthrough mode to show the real world through the headset. The users are able to click and drag using the controllers to create a box. This box can be resized by dragging the faces, or moved by ``grabbing'' it. In addition, a selection of furniture models can be applied to the box. Overall, the app allows users to measure furniture in real life, apply a model so they remember what it represents, and move it to another location to see how much space it takes up in a different location.

The project was implemented in Godot 4.4 using a Meta Quest Pro headset.

# Features

This program allows the user to click and drag with the controller triggers to create a box. They can then click and drag the faces of the box to resize it. The faces change color when being hovered to show which faces will be manipulated. The box can be moved by click and dragging it with the grab trigger. To delete the boxes, the users can drag the faces close together (below a certain size threshold) and they will disappear out of existence.

The user can also press the X button on the left controller to open a popup menu with a list of furniture objects. The menu can be navigated with the left thumbstick. To select a furniture model, the user must click the A button on the right controller. This will show the furniture model hovering over the right controller. It can be rotated in 90 degree increments using the right thumbstick. To apply the furniture model to a box, the box must be hovered and the right trigger must be pressed. At that point, the furniture model will move and scale with the box.

# Screenshots

![box](https://github.com/user-attachments/assets/c410b85f-3c96-4e10-a9c1-7c0af7ca4744)

![menu2](https://github.com/user-attachments/assets/ebe84ec3-937a-4e1f-a134-32cc6a9f8dd0)


![misc2](https://github.com/user-attachments/assets/dd564412-8047-4586-b056-31535c17c2f8)
