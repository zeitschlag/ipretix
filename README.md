# iPRETIX

**Development happens mostly at [GitLab](https://gitlab.com/zeitschlag/ipretix/issues) at the moment. It is [planned to move to Github](https://gitlab.com/zeitschlag/ipretix/issues/14) in the near future. So: Please consider this repo WIP. Thanks.**

## Goals for 1.0

universal iOS-app to scan and validate pretix-tickets

### Configuration
- User scans the pretixdroid configuration-QR-code to read the configuration
- this configuration contains a json with a secret key, the URL, and 'allow_search', which defines, whether the user is allowed to use the manual search (or not)
- use the secret key in the `Authorization: Token`-Header when talking to the API

### Sync
- uploads all locally redeemed tickets
- downloads new tickets once in a while (like every 5 Minutes?) from the pretix-API and checks, which one to add, which one to delete and which one to update. (that's at least, what the SyncManager seems to do, why not adopt this, as it seems to be robust?)

### Scan Tickets
- the app needs to ask the user for permission to use the camera to scan ticket
- read the secret from the qr-code from a pretix-ticket/wallet
- validate it against downloaded ticket-data (== compared the secret from the qr-code with the downloaded ticket data. if it's found, redeem it.)

### Manual Search/Manual redeeming
- Users can search the locally available list of ticket data for order-number or attendee name
- Users can manually redeem tickets (if an attendee forgot to bring the ticket)

## TODO

- [ ] find a better name
