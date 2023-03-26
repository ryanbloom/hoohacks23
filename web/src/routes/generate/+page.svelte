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
        fetch('https://fastapi-projectgpt.herokuapp.com/generate-url', {
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
<div style='display:flex; flex-direction:column'>
<input type='text' placeholder='Paste article URL' bind:value={prompt} />
<div class="button-container">
<button on:click={generate}>Generate flashcards</button>
</div>
{#if loading}
    <p>Analyzing article...</p>
{/if}

</div>
<style></style>
