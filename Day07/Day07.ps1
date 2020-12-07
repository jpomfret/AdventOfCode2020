# import the data
$luggageRules = Get-Content .\sample.txt

#Region Part1
# parse the rules into an object
$rules = @()
foreach ($lrule in $luggageRules) {
    $pattern = "(\w+ \w+)(?=\s+bag)"
    $results = $lrule | Select-String $pattern -AllMatches

    $rules += [PSCustomObject]@{
        Outer = $results.Matches.Value[0]
        Inner = $results.Matches.Value[1..($results.Matches.Length)]
    }
}

$total = @()
$myBag = 'shiny gold'

# Initial bags
$bags = $rules | Where-Object Inner -contains $myBag
$total += $bags

# loop through bags that can contain bag
while ($bags) {
    $work = $bags.clone()

    $bags = @()
    $work.Outer | ForEach-Object -PipelineVariable outer -Process {$_} | ForEach-Object {
        $bags +=  $rules | Where-Object Inner -contains $outer
        $total += $bags
    }

}

Write-Host ('Part 1: {0} can contain the shiny gold bag' -f ($total | select -Unique outer | measure))
#EndRegion

#Region Part2

#EndRegion