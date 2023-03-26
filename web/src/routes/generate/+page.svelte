<script lang='ts'>
    import { cards, nextId } from '../../stores.js';

    let prompt = '';
    let loading = false;

    function generate() {
        loading = true;
        fetch('http://localhost:8000/generate/?prompts=' + prompt)
            .then(response => response.text())
            .then(text => {
                let newCard = {
                    'front': prompt,
                    'back': text,
                    'id': $nextId,
                    'dateLastStudied': 'dateLastStudied'
                }
                console.log(newCard);
                nextId.update(id => id + 1)
                cards.update(c => [...c, newCard])
                loading = false;
            })
    }
</script>
<h2>Generate cards</h2>

<input type='text' bind:value={prompt} />
<button on:click={generate}>Generate card!</button>
{#if loading}
    <p>Loading...</p>
{/if}
