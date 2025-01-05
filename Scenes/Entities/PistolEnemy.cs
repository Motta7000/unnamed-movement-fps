using Godot;
using System;

public partial class PistolEnemy : Node3D
{
	[Export] public float ShootingInterval = 2.0f; // Time between shots
	[Export] public PackedScene ProjectileScene; // Reference to the projectile scene
	[Export] public float ProjectileSpeed = 50.0f; // Speed of the projectiles
	[Export] public NodePath PlayerPath; // Path to the player node

	private Node3D _gunBarrel; // Position where projectiles spawn
	private Timer _shootTimer; // Timer to control shooting
	private Node3D _player; // Reference to the player

	public override void _Ready()
	{
		GD.Print("Executing _Ready() PistolEnemy");
		// Get references to nodes
		_gunBarrel = GetNode<Node3D>("GunBarrel");
		_shootTimer = GetNode<Timer>("ShootTimer");

		// Attempt to locate the player
		if (!string.IsNullOrEmpty(PlayerPath))
		{
			_player = GetNode<Node3D>(PlayerPath);
		}

		// Enable processing
		SetProcess(true);

		// Set up the timer for shooting
		_shootTimer.WaitTime = ShootingInterval;
		_shootTimer.Autostart = true;
		_shootTimer.Timeout += Shoot; // Connect the timer timeout to the shoot function
	}

	public void Process(float delta)
	{
		// Continuously look at the player
		if (_player != null)
		{
			LookAt(_player.GlobalTransform.Origin);
		}
	}

	private void Shoot()
	{
		GD.Print("Enemy shot a bullet");
		if (ProjectileScene == null || _player == null)
		{
			GD.PrintErr("ProjectileScene not set or Player not found.");
			return;
		}

		// Instance the projectile and add it to the scene
		Node projectileInstance = ProjectileScene.Instantiate();
		GetParent().AddChild(projectileInstance);

		// Position and orient the projectile
		if (projectileInstance is RigidBody3D projectile)
		{
			// Position the projectile at the gun barrel
			projectile.GlobalTransform = _gunBarrel.GlobalTransform;

			// Calculate direction towards the player
			Vector3 direction = (_player.GlobalTransform.Origin - _gunBarrel.GlobalTransform.Origin).Normalized();

			// Set the projectile's velocity
			projectile.LinearVelocity = direction * ProjectileSpeed;
		}
	}
}
