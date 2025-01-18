using Godot;
using System;

public partial class MainMenuCamera3d  : Camera3D
{
    [Export]
    public float rotationSpeed = 1f;
    public override void _Ready()
    {
    }
    public override void _Process(double delta)
    {
        GD.Print(Mathf.DegToRad(rotationSpeed * (float)delta));
        RotateY(Mathf.DegToRad(rotationSpeed * (float)delta));
    }
}
