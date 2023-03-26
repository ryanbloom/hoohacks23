<script lang='ts'>
    import { cards, nextId } from '../../stores.js';

    let prompt = '';
    let loading = false;

    function generate() {
        loading = true;
        let json_object = {
            'url': prompt
        };

        // Post json_object to the api endpoint
        fetch('http://localhost:8000/generate-url', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(json_object)
        })
            .then(response => response.json())
            .then(data => {
                // Add the cards to the store
                cards.update(cards => {
                    console.log('old cards', cards)
                    console.log('data', data)
                    let newCards = [];
                    for (let card of data) {
                        newCards.push({
                            id: $nextId,
                            front: card.front,
                            back: card.back,
                            dynamic: card.dynamic
                        });
                        nextId.update(id => id + 1);
                    }
                    console.log('new cards', newCards)
                    return [...cards, ...newCards];
                })
            })
            .then(_ => {
                loading = false;
            });
    }
</script>
<h2>Generate cards</h2>

<input type='text' bind:value={prompt} />
<button on:click={generate}>Generate card!</button>
{#if loading}
    <p>Loading...</p>
{/if}
