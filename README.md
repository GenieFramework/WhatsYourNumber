# whats-your-number

Demo app for Stipple.jl

See it live at: https://stipple-whatsyournumber.herokuapp.com

## Instructions

1. Download/clone, and start a Julia REPL inside the app's folder. 
2. Go into `pkg>` mode (by pressing `]`)
3. Run `pkg> instantiate`

### Run the app

#### Option 1 -- using the provided app runners

4. Exit the repl
6. At the terminal start the app by running `bin/server` (or `bin/server.bat` for Windows - make sure the files can be executed, run `chmod +x bin/server` if necessary. You may also need to update the path to the `julia` binary to match your system in the `bin/server` files).

#### Option 2 -- using the Genie API
4. Go back to the Julia `julia> ` mode by pressing backspace to exit `pkg> ` mode
5. Run `julia> using Genie`
6. Run `julia> Genie.loadapp()`
7. Run `julia> up()` to start the web server.

##### Please comment, contribute, open issues to make this better! 
