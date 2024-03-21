## summary

1. creates an object on queueAction() :

   - caller should have "more than" half token in the contract.
   - target cannot be SimpleGovernance Contract

   {
   target: target address,
   value: amount to be sent to target,
   proposedAt: currentTime,
   executedAt: 0,
   data: data function to be called when about to send the money to target
   }

2. executes the data for the particular target using executeAction(actionId):
   - atleast 2 days must have past @proposedAt
   - cannot execute if @proposedAt is 0
   - fills executedAt
   - calls target's sends value & data
