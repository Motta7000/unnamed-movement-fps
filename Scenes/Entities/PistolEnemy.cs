using Godot;
using System;

public partial class PistolEnemy : Node3D
{
	[Export] public float ShootingInterval = 2.0f; // Time between shots
	[Export] public PackedScene ProjectileScene; // Reference to the projectile scene
	[Export] public float ProjectileSpeed = 50.0f; // Speed of the projectiles
	[Export] public NodePath PlayerPath; // Path to the player node
	[Export] public int MaxHealth = 100; // Enemy's maximum health

	private Node3D _gunBarrel; // Position where projectiles spawn
	private Timer _shootTimer; // Timer to control shooting
	private Node3D _player; // Reference to the player
	private int _currentHealth; // Enemy's current health
	private Node gameManager;
public override void _Ready()
{
	GD.Print("Executing _Ready() PistolEnemy");
	gameManager = GetNode("/root/GameManager");
	// Initialize health
	_currentHealth = 1;

	// Get references to nodes
	_gunBarrel = GetNode<Node3D>("GunBarrel");
	_shootTimer = GetNode<Timer>("ShootTimer");
	var players = GetTree().GetNodesInGroup("player");
	if (players.Count > 0)
	{
		_player = players[0] as Node3D;
		GD.Print("Player found via group.");
	}

	// Attempt to locate the player
	if (!string.IsNullOrEmpty(PlayerPath))
	{
		_player = GetNode<Node3D>(PlayerPath);
	}

	// Enable processing
	SetPhysicsProcess(false); // For physics-related processing
	SetProcess(true); // For regular frame updates

	// Set up the timer for shooting
	Random random = new Random();
	_shootTimer.WaitTime = ShootingInterval * (1.0 + (random.NextDouble() * 0.2 - 0.1));
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
			// Calculate direction towards the player
			Vector3 direction = (_player.GlobalTransform.Origin - _gunBarrel.GlobalTransform.Origin).Normalized();
			// Position the projectile at the gun barrel
			projectile.GlobalTransform = _gunBarrel.GlobalTransform.Translated(direction * 1.5f);
			// Set the projectile's velocity
			projectile.LinearVelocity = direction * ProjectileSpeed;
		}
	}

	public void TakeDamage(int amount)
	{
		_currentHealth -= amount;
		GD.Print($"Enemy took {amount} damage. Current health: {_currentHealth}");

		if (_currentHealth <= 0)
		{
			Die();
		}
	}

	private void Die()
	{
		GD.Print("Enemy is dead!");
		gameManager.Call("enemy_game_ended");
		// Add death effects, e.g., explosion, sound, etc.
		QueueFree(); // Remove the enemy from the scene
	}
}
