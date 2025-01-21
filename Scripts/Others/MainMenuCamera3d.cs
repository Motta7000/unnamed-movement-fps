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
        RotateY(Mathf.DegToRad(rotationSpeed * (float)delta));
    }
}
