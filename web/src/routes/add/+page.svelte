<script lang="ts">
    import { cards, nextId } from '../../stores.js';
	let front = '';
	let back = '';
    // let id = 0;
    let cardsData = []

    cards.subscribe(value => {
		cardsData = value;
	});
    
    function click() {
        if (front == '' || back == '') {
            alert("You cannot have an empty card!")
            return;
        }

        let newCard = {
            'front': front,
            'back': back,
            'id': $nextId,
            'dateLastStudied': 'dateLastStudied'
        }

        nextId.update(id => id + 1);
        cards.update(c => [...c, newCard])
    }
</script>

<!-- Center everything inside this div -->
<div class='outer'>
    <div style='display:flex;flex-direction:column;width:500px;'>
        <input placeholder="Front" bind:value={front}>
        <input placeholder="Back" bind:value={back}>
    </div>
    <div class="button-container">
        <button on:click={click}>Create Card</button>
        <a href='/'><button>Go back home</button></a>
    </div>
    {#if cardsData.length > 0}
        <div class='card-list'>
            <ul>
                {#each cardsData as card}
                    <li>{card.id}: {card.front} | {card.back}</li>
                {/each}
            </ul>
        </div>
    {/if}
</div>

<style>
    .card-list {
        background: rgba(0, 0, 0, 0.5);
        border: solid white 2px;
        border-radius: 6px;
    }

    input {
        width: 300;
    }

    button {
        width: 150px;
        height: 50px;
    }

    .outer {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    ul {
        padding-right: 40px;
    }

</style>
