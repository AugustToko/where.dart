#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)
dartanalyzer --options=analysis_options.yaml --packages=.dart_tool/package_config.json bin lib test
