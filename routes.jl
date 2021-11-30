using Genie, Stipple, StippleUI, StipplePlotly
using Random

if isprod()
  for m in [Genie, Stipple, StippleUI, StipplePlotly]
    m.assets_config.host = "https://cdn.statically.io/gh/GenieFramework"
  end
end

#== data ==#

list_of_numbers = Int[]

function plotdata()
  PlotData(
    x = list_of_numbers,
    plot = StipplePlotly.Charts.PLOT_TYPE_HISTOGRAM,
    marker = Dict(:color => "#" * randstring(['0':'9'; 'a':'f'], 6)),
    nbinsx = 100
  )
end

#== reactive model ==#

@reactive struct Model <: ReactiveModel
  #UI
  choice::R{String} = ""
  errormessage::R{String} = ""
  error::R{Bool} = false
  process::R{Bool} = false

  # plot
  data::R{Vector{PlotData}} = [plotdata()]
  layout::PlotLayout = PlotLayout(plot_bgcolor = "#fff")
  config::PlotConfig = PlotConfig()
end

#== handlers ==#

function validvalue(model, val)
  if isempty(val)
    model.error[] = false
    model.errormessage[] = ""

    return
  end

  v = tryparse(Int, val)

  if v === nothing
    model.error[] = true
    model.errormessage[] = "Oh dear, '$val' does not look like a proper whole number. Try again?"
  elseif ! (v in 1:100)
    model.error[] = true
    model.errormessage[] = "Oh my, I fear that '$val' is not between 1 and 100...?"

    return nothing
  else
    model.error[] = false
    model.errormessage[] = ""
  end

  v
end

function processval(model, v)
  push!(list_of_numbers, v)

  model.data[] = [plotdata()]
  model.process[] = false
  model.choice[] = ""
end

function handlers(model)
  on(model.process) do val
    val || return

    v = validvalue(model, model.choice[])
    if v === nothing
      model.process[] = false
      return
    end

    processval(model, v)
  end

  on(model.choice) do val
    v = validvalue(model, val)
  end

  model
end

#== ui ==#

function ui(model)
  page(model, [
      heading("What's your number?")

      row([
        cell(class="st-module", [
          textfield("Write your number and see if others dig it too (just press ENTER when done)",
                    :choice, @on("keyup.enter", "process = true"),
                    clearable = true, filled = true, errormessage = :errormessage, error = :error
                  )
        ])
      ])

      row([
        cell(class="st-module", [
          h6("Numbers distribution")
          plot(:data, layout = :layout, config = :config, style="margin-top: -10pt;")
        ])
      ])

      row([
        footer([
          h6("Powered by Stipple")
        ])
      ])

    ], @iif(:isready)
  )
end

#== server ==#

route("/") do
  Model() |> init |> handlers |> ui |> html
end

# isrunning(:webserver) || up()