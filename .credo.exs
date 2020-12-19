%{
  configs: [
    %{
      name: "default",
      files: %{
        excluded: [
          ~r"/_build/",
          ~r"/deps/",
          ~r"/assets/"
        ]
      },
      checks: [
        {Credo.Check.Design.TagTODO, exit_status: 0},
        {Credo.Check.Refactor.MapInto, false},
        {Credo.Check.Warning.LazyLogging, false},
        {Credo.Check.Readability.PreferImplicitTry, false}
      ],
      strict: true
    }
  ]
}
