# Pinned to an unstable 0.10.0 revision because that revision carries the
# current Google Flights protocol implementation. `click` is added because
# upstream imports it without declaring it as a dependency.
{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  babel,
  click,
  curl-cffi,
  fastapi,
  fastmcp,
  httpx,
  plotext,
  pydantic,
  pydantic-settings,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  ratelimit,
  tenacity,
  typer,
  uvicorn,
}:

buildPythonPackage {
  pname = "flights";
  version = "0.10.0-unstable-2026-05-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "punitarani";
    repo = "fli";
    rev = "121d34fea056dc513258958c4262cb5a4cc033c1";
    hash = "sha256-SJk4fGqL3xnU505TI+3oHd1+YqlvoVKcN3W+8jKqGmI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    babel
    click
    curl-cffi
    fastapi
    fastmcp
    httpx
    plotext
    pydantic
    pydantic-settings
    python-dotenv
    ratelimit
    tenacity
    typer
    uvicorn
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [ "tests/search" ];

  disabledTests = [
    # These tests query the live Google Flights service.
    "test_search_flights_one_way"
    "test_search_flights_round_trip"
    "test_search_dates_one_way"
    "test_search_dates_round_trip"
  ];

  pythonImportsCheck = [
    "fli"
    "fli.cli"
    "fli.mcp"
  ];

  meta = {
    description = "Google Flights CLI, Python library, and MCP servers";
    homepage = "https://github.com/punitarani/fli";
    license = lib.licenses.mit;
    mainProgram = "fli";
  };
}
