package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

const (
	serverRepo = "https://github.com/ue555/vim9-lsp-server"
	serverName = "vim9-lsp-server"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Usage: vim9-lsp-setup <install-path>")
		os.Exit(1)
	}

	installPath := os.Args[1]
	serverPath := filepath.Join(installPath, serverName)

	// Check if already installed
	if _, err := os.Stat(serverPath); err == nil {
		fmt.Printf("✓ vim9-lsp-server already installed at %s\n", serverPath)
		if err := updateServer(serverPath); err != nil {
			fmt.Fprintf(os.Stderr, "Warning: Failed to update server: %v\n", err)
		}
	} else {
		// Clone the repository
		if err := cloneServer(installPath, serverPath); err != nil {
			fmt.Fprintf(os.Stderr, "Error: Failed to clone server: %v\n", err)
			os.Exit(1)
		}
	}

	// Check Node.js
	if err := checkNodeJS(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	// Build server
	if err := buildServer(serverPath); err != nil {
		fmt.Fprintf(os.Stderr, "Error: Failed to build server: %v\n", err)
		os.Exit(1)
	}

	// Verify installation
	if err := verifyServer(serverPath); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("✓ vim9-lsp-server setup completed successfully!")
}

func cloneServer(installPath, serverPath string) error {
	fmt.Printf("Cloning vim9-lsp-server to %s...\n", serverPath)

	// Create install directory if it doesn't exist
	if err := os.MkdirAll(installPath, 0755); err != nil {
		return fmt.Errorf("failed to create install directory: %w", err)
	}

	cmd := exec.Command("git", "clone", serverRepo, serverPath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("git clone failed: %w", err)
	}

	fmt.Println("✓ Repository cloned successfully")
	return nil
}

func updateServer(serverPath string) error {
	fmt.Println("Updating vim9-lsp-server...")

	cmd := exec.Command("git", "-C", serverPath, "pull")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return err
	}

	fmt.Println("✓ Repository updated successfully")
	return nil
}

func checkNodeJS() error {
	fmt.Println("Checking Node.js installation...")

	cmd := exec.Command("node", "--version")
	output, err := cmd.Output()
	if err != nil {
		return fmt.Errorf("Node.js is not installed or not in PATH")
	}

	fmt.Printf("✓ Node.js found: %s", output)
	return nil
}

func buildServer(serverPath string) error {
	fmt.Println("Installing dependencies...")

	// npm install
	cmd := exec.Command("npm", "install")
	cmd.Dir = serverPath
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("npm install failed: %w", err)
	}

	fmt.Println("✓ Dependencies installed")
	fmt.Println("Building server...")

	// npm run build
	cmd = exec.Command("npm", "run", "build")
	cmd.Dir = serverPath
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("npm run build failed: %w", err)
	}

	fmt.Println("✓ Server built successfully")
	return nil
}

func verifyServer(serverPath string) error {
	serverBinary := filepath.Join(serverPath, "out", "server.js")

	if _, err := os.Stat(serverBinary); err != nil {
		return fmt.Errorf("server binary not found at %s", serverBinary)
	}

	fmt.Printf("✓ Server binary verified at %s\n", serverBinary)
	return nil
}
