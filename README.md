# 🐚 Shapi: From Shell to API 🌐

Welcome to the Shapi repository! This project bridges the gap between shell scripting and API development, allowing users to create efficient and powerful applications with ease. Whether you are a seasoned developer or just starting out, Shapi offers tools that simplify your workflow and enhance your productivity.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Topics](#topics)
- [Contributing](#contributing)
- [License](#license)
- [Releases](#releases)
- [Contact](#contact)

## Introduction

Shapi stands for "Shell to API." It transforms shell commands into RESTful APIs. This allows developers to leverage existing scripts and tools while providing a clean interface for users and applications. 

With Shapi, you can quickly generate APIs from shell scripts, making it easier to integrate command-line tools into web applications or other services.

## Features

- **Easy Integration**: Convert shell commands into REST APIs effortlessly.
- **CLI Tool**: Use Shapi from the command line to generate and manage APIs.
- **Cursor Support**: Handle interactive command-line applications with ease.
- **Customizable**: Tailor the generated APIs to fit your needs.
- **Multiple Backends**: Supports various backends like Mistral and Ollama.
- **Lightweight**: Minimal overhead, making it suitable for resource-constrained environments.
- **Open Source**: Contribute to the project and help it grow.

## Installation

To get started with Shapi, follow these simple steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Mohammed10106/shapi.git
   cd shapi
   ```

2. **Install Dependencies**:
   Make sure you have the required dependencies installed. You can use a package manager like `apt` or `brew` to install them.

3. **Run the Setup Script**:
   Execute the setup script to install Shapi:
   ```bash
   ./setup.sh
   ```

4. **Verify Installation**:
   Check if Shapi is installed correctly:
   ```bash
   shapi --version
   ```

## Usage

Using Shapi is straightforward. Here’s how you can create an API from a shell command:

1. **Create a Shell Script**:
   Write a shell script that you want to convert into an API. For example, create a file named `hello.sh`:
   ```bash
   #!/bin/bash
   echo "Hello, World!"
   ```

2. **Make the Script Executable**:
   Change the permissions to make it executable:
   ```bash
   chmod +x hello.sh
   ```

3. **Generate the API**:
   Use Shapi to generate the API:
   ```bash
   shapi generate hello.sh
   ```

4. **Run the API**:
   Start the API server:
   ```bash
   shapi start
   ```

5. **Access the API**:
   You can now access your API at `http://localhost:8080/hello`.

## Topics

Shapi covers a variety of topics that enhance its functionality:

- **API**: Create and manage RESTful APIs.
- **Bash**: Utilize the power of shell scripting.
- **CLI**: Command-line interface for ease of use.
- **Cursor**: Support for interactive applications.
- **Generator**: Automatically generate APIs from scripts.
- **LLM**: Integrate with large language models for advanced functionalities.
- **Mistral**: Support for the Mistral backend.
- **Ollama**: Integrate with the Ollama backend.
- **REST**: Follow RESTful principles for API design.
- **Script**: Convert scripts into APIs.
- **Shell**: Leverage shell scripting capabilities.
- **Windsurf**: Utilize windsurfing tools for performance optimization.

## Contributing

We welcome contributions from the community! Here’s how you can help:

1. **Fork the Repository**: Click the fork button on GitHub to create your copy.
2. **Create a Branch**: Use a descriptive name for your branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make Changes**: Implement your changes and test them.
4. **Commit Your Changes**:
   ```bash
   git commit -m "Add your message here"
   ```
5. **Push to GitHub**:
   ```bash
   git push origin feature/your-feature-name
   ```
6. **Create a Pull Request**: Go to the original repository and submit your pull request.

## License

Shapi is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Releases

You can download the latest release of Shapi from the [Releases section](https://github.com/Mohammed10106/shapi/releases). Download the file and execute it to get started.

For more information on updates and new features, check the [Releases section](https://github.com/Mohammed10106/shapi/releases).

## Contact

If you have any questions or suggestions, feel free to reach out:

- **Email**: your-email@example.com
- **Twitter**: [@yourhandle](https://twitter.com/yourhandle)
- **GitHub**: [Your GitHub Profile](https://github.com/yourprofile)

---

Thank you for checking out Shapi! We hope you find it useful for your projects. Happy coding!