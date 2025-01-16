using Godot;
using System;

public partial class Projectile : RigidBody3D
{
	[Export] public float Speed = 50.0f;  // Speed of the projectile
	public Vector3 direction = Vector3.Zero;  // Make direction public
	private MeshInstance3D mesh;
	private CollisionShape3D collisionShape;
	private RayCast3D ray;
	[Export] public int Damage = 1;  // Damage dealt by the projectile
	private bool TimerOn = true;

	private Timer hitTimer;  // Declare a timer variable

	public override void _Ready()
	{
		// Set the linear velocity to move the projectile
		GravityScale = 0;
		LinearVelocity = direction * Speed;

		// Create and configure the timer
		hitTimer = new Timer();
		AddChild(hitTimer);  // Add the timer to the scene tree
		hitTimer.WaitTime = 0.0000001f;  // Set the timer duration (to avoid immediate self-damage)
		hitTimer.OneShot = true;  // Make the timer one-shot

		// Connect the timeout signal to the function
		hitTimer.Timeout += _OnTimerTimeout;
		hitTimer.Start();

		// Optional: Destroy the projectile after 25 seconds
		GetTree().CreateTimer(25).Timeout += () => QueueFree();
	}

	public void Process(float delta)
	{
		if (ray.IsColliding() && !TimerOn)
		{
			var collider = ray.GetCollider();  // Get the node hit by the ray
			while (collider != null)
			{
				if (collider is Node node && node.HasMethod("TakeDamage"))
				{
					node.Call("TakeDamage", Damage);  // Call the TakeDamage method
					break;
				}
				collider = (collider as Node)?.GetParent();  // Move up the tree
			}

			// Handle projectile behavior after collision
			mesh.Visible = false;
			LinearVelocity = Vector3.Zero;
		}
	}

	private void _OnTimerTimeout()
	{
		// Bullet can hit something now
		TimerOn = false;
	}
}
