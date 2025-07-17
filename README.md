# Antimetal APIs

This repository contains interface definitions for public Antimetal APIs.

You can use these definitions to generate your own client libraries and other artifacts for your own purposes.

The interface definitions are defined using [Protocol Buffers](https://protobuf.dev/) verison 3 (proto3).
We use [Buf](https://buf.build/) to manage the Protobuf files.

Note: We will add proper high-level documentation for the APIs in the future, but the protobuf files should be reasonably well documented.

## Repository Structure

`api` is the root directory for all Antimetal APIs where each API is its own subdirectory.
Each API directory then has subdirectories for each major version of the API.
So for example, the path for `foo` API is `api/foo/v1`. A v2 version would be `api/foo/v2`.
This makes it easy to locate the proto definitions for a particular API.

## Publishing to Buf Registry

The protobuf definitions are automatically published to the Buf registry on every push to the main branch via GitHub Actions.
The workflow uses the same buf version specified in `go.mod` to ensure consistency.
