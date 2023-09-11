defmodule DocusignBackupTest do
  use ExUnit.Case
  doctest DocusignBackup

  test "greets the world" do
    assert DocusignBackup.hello() == :world
  end
end
