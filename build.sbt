ThisBuild / version := "1.0"
ThisBuild / scalaVersion := "2.12.15"
ThisBuild / organization := "org.example"

val spinalVersion = "1.7.2"
val spinalCore = "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion
val spinalLib = "com.github.spinalhdl" %% "spinalhdl-lib" % spinalVersion
val spinalIdslPlugin = compilerPlugin("com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion)
val pb = "com.github.nscala-time" %% "nscala-time" % "2.26.0"
val jline = "jline" % "jline" % "2.13"

lazy val mylib = (project in file("."))
  .settings(
    name := "CAxiMemTransfer",
    organization := "cn.edu.tsinghua",
    version := "1.0",
    scalaVersion := "2.12.15",
    Compile / scalaSource := baseDirectory.value / "src" / "main",
    libraryDependencies ++= Seq(spinalCore, spinalLib, spinalIdslPlugin, pb, jline)
  )

fork := true
