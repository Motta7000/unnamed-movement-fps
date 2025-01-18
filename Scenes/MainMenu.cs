using Godot;
using System;

public partial class MainMenu : Control
{
	private Button startButton;
	private VBoxContainer vBox;
	public override void _Ready()
	{
		vBox = GetNode<VBoxContainer>("VBoxContainer");
		vBox.GrabFocus();
		startButton = vBox.GetNode<Button>("StartButton");
	}
	public void OnStartButtonPressed()
	{
		GetTree().ChangeSceneToFile("res://Scenes/Level 1.tscn");
	}
	public void OnExitButtonPressed()
	{
		GetTree().Quit();
	}
}
