<template>
    <b-container>
        <LoadingIcon center v-if='itinerary===null && !failedLoad && isEditMode'></LoadingIcon>
        <br>
        <GmapMap id='googleMap'
            :center="{lat:12, lng:12}"
            :zoom="12"
            :options='$root.mapOptions'
            map-type-id="terrain"
            style="width: 80%; height: 300px; margin-left: 10%;" 
            ref="map"
            >   
        </GmapMap>
        <b-form-select v-on:change='UpdateRoutes' v-model="selectedMode" style='width: 100px; float: right;' :options="travelOptions"></b-form-select>
        <br>
        <br>
        <b-button variant="primary" @click='displaySteps = !displaySteps' class='removeButton'>Toggle Step By Step Directions</b-button>
        <br>
        <h2>Your Itinerary:</h2>
        <h3>{{iName}}</h3>
        <br>
        <draggable v-model="landmarks" @change='UpdateRoutes()' group="name" @start="drag=true" @end="drag=false" draggable='.landmarkItem'>
            <b-list-group-item class='landmarkItem' v-for="landmark in landmarks" :key="landmark.id">
                Stop {{landmarks.indexOf(landmark) + 1}}: {{landmark.name}}
            </b-list-group-item>
        </draggable>
        <br>
        <b-list-group v-if="displaySteps">
            <b-list-group-item v-for='(step, index) in routeSteps' :key="index">
                {{index + 1}}:     <span style='margin-left: 20px' v-html='step.instructions'></span><span style='float: right'>{{step.distance.text}}</span>
            </b-list-group-item>
        </b-list-group>
        <WriteReview ref='editor' @review-edited='ReviewEdited' @review-submitted='ReviewSubmitted' v-if="signedIn" :typeId=this.id apiPath='review/itinerary/'></WriteReview>
        <br>
        <br>
        <h3>Reviews of This Itinerary:</h3>
        <Reviews ref='reviews' apiPath='review/itinerary/'></Reviews>
        <br><br>
    </b-container>
</template>

<script>
import draggable from 'vuedraggable';
import auth from '../auth';
import mapsHelper from '../mapsHelper';
import Reviews from './components/Review.vue';
import WriteReview from './components/WriteReview';
export default {
    name: "Itinerary",
    components: {
        draggable,
        Reviews,
        WriteReview
    },
    computed: {
        isOwner: function()
        {
            if(this.itinerary == null)
            {
                return false;
            }
            return this.signedIn && this.userID == this.itinerary.ownerID;
        }
    },
    data() {
        return {
            failedLoad: false,
            itinerary: null,
            isEditMode: false,
            landmarks: [],
            alertTime: 0,
            id: this.$route.params.id,
            iName: "",
            coordinates: null,
            successTime: 0,
            failedTime: 0,
            signedIn: auth.getUser() != null,
            userID: -1,
            directionsService: null,
            directionsDisplay: null,
            selectedMode: "DRIVING",
            travelOptions: [
                {value: "DRIVING", text: "Driving"},
                {value: "WALKING", text: "Walking"},
                {value: "BICYCLING", text: "Biking"}
            ],
            routeSteps: [],
            displaySteps: false
        };
    },
    created(){
        if(this.signedIn)
        {
            this.userID = auth.getUser().id;
        }
        if(this.id != undefined)
        {
            this.isEditMode = true;
            this.getItinerary();
        }
        else{
            this.itinerary = {};
            this.itinerary.ownerID = this.userID;
        }
        
        this.$bus.$on('login', () => {
        if(auth.getToken() != null)
        {
          this.signedIn = true;
        }
        })
    },
    mounted: function() {
        
    },
    methods: {
        getItinerary()
        {
            fetch(`${process.env.VUE_APP_REMOTE_API}/api/itinerary/` + this.id, {
                method: 'GET',
                headers: {
                Accept: 'application/json',
                'Content-Type': 'application/json',
                }
            })
            .then((response) => {
                if (response.ok) {
                    return response.json();
                }
                else{
                    this.itineraryNotFound();
                }
            })
            .then((itinerary) => {
                this.itinerary = itinerary;
                this.iName = itinerary.name;
                this.coordinates = {lat: itinerary.startLat, lng: itinerary.startLng};
                this.populateLandmarks();
            })
            .catch((err) => {
                console.log(err);
                this.itineraryNotFound()
            });
        },
        itineraryNotFound()
        {
            this.failedLoad = true;
        },
        populateLandmarks()
        {
            for(let i = 0; i < this.itinerary.landmarks.length; i++)
            {
                let landmark = {};
                landmark.name = this.itinerary.landmarks[i].longName;
                landmark.id = this.itinerary.landmarks[i].id;
                landmark.location = {lat: this.itinerary.landmarks[i].latitude, lng: this.itinerary.landmarks[i].longitude};
                this.landmarks.push(landmark);
            }
            this.UpdateRoutes();
        },
        UpdateRoutes()
        {
            
            if(this.landmarks.length >= 1)
            {
                mapsHelper.RequestMap( this.PerformRouteUpdate);
               
            }
            else{
                if(this.directionsDisplay !== null)
                {
                    this.directionsDisplay.setMap(null);
                }
            }
        },
        PerformRouteUpdate()
        {
            let waypoints = [];
            if(this.landmarks.length >= 2)
            {
                for(let i = 0; i < this.landmarks.length - 1; i++)
                {
                    waypoints.push({location: this.landmarks[i].location, stopover: true});
                }
            }
            this.getRoute({lat: this.itinerary.startLat, lng: this.itinerary.startLng}, this.landmarks[this.landmarks.length - 1].location, waypoints, this.selectedMode)
        },
        getRoute: function (origin, destination, stops, method) {
            if(this.directionsService == null)
            {
                this.$gmapApiPromiseLazy().then(gmap => {
                    this.directionsService = new gmap.maps.DirectionsService()
                    this.directionsDisplay = new gmap.maps.DirectionsRenderer()
                    this.PerformRouteRequest(origin, destination, stops, method);
                });
                
            }
            else{
                this.PerformRouteRequest(origin, destination, stops, method);
            }
        },
        PerformRouteRequest(origin, destination, stops, method)
        {
            var vm = this
            this.directionsDisplay.setMap(this.$refs.map.$mapObject)
            vm.directionsService.route({
                origin: origin, 
                destination: destination,
                travelMode: method,
                waypoints: stops
            },  (response, status) => {
                if (status === 'OK') {
                    this.routeSteps = response.routes[0].legs[0].steps;
                    for(let i = 1; i < response.routes[0].legs.length; i++)
                    {
                        this.routeSteps = this.routeSteps.concat(response.routes[0].legs[i].steps);
                    }
                    vm.directionsDisplay.setDirections(response) // draws the polygon to the map
                } else {
                    console.log('Directions request failed due to ' + status)
                }
            });
        },
        ReviewSubmitted(review){
            this.$refs.reviews.AddReview(review);
        },
        ReviewEdited(review){
            this.$refs.reviews.EditReview(review);
        }
    }
}
</script>

<style scoped>
    .landmarkItem{
        cursor: grab;
    }
    .removeButton{
        float: right;
        margin-top: -7px;
    }
</style>